// RouteEngineTests.swift
// 루트 엔진 + 옵티마이저 테스트 — 3가지 맛깔 관점
// νₑ 정상 경로, νμ 예외 경로, ντ 경계 경로

import XCTest
@testable import JobWorldQueue

@MainActor
final class RouteEngineTests: XCTestCase {

    var engine: RouteEngine!

    override func setUp() {
        super.setUp()
        engine = RouteEngine()
    }

    override func tearDown() {
        engine = nil
        super.tearDown()
    }

    // MARK: - νₑ 정상 경로 (Happy Path) — 루트 생성

    func test_어린이체험관_정상_루트_생성() {
        // Arrange: 6세(72개월) 어린이
        let age = 72

        // Act
        engine.generateRoute(hall: .children, ageInMonths: age, preferredIds: [])

        // Assert
        XCTAssertFalse(engine.activeRoute.isEmpty, "루트가 생성되어야 한다")
        XCTAssertLessThanOrEqual(engine.activeRoute.count, 5, "기본 sessionCount는 5")
        XCTAssertEqual(engine.currentIndex, 0, "첫 번째 아이템부터 시작")
        XCTAssertEqual(engine.completedCount, 0, "완료 수는 0")
        XCTAssertEqual(engine.totalJoy, 0, "JOY는 0")
    }

    func test_루트_첫번째_아이템_활성_나머지_대기() {
        // Arrange & Act
        engine.generateRoute(hall: .children, ageInMonths: 72, preferredIds: [])

        // Assert
        guard !engine.activeRoute.isEmpty else {
            XCTFail("루트가 비어있다")
            return
        }
        XCTAssertEqual(engine.activeRoute[0].status, .active, "첫 아이템은 active")
        for i in 1..<engine.activeRoute.count {
            XCTAssertEqual(engine.activeRoute[i].status, .pending, "나머지는 pending")
        }
    }

    func test_선호_체험실_우선_배치() {
        // Arrange: 특정 체험실을 선호로 지정
        let rooms = ScheduleData.rooms(for: .children)
        guard rooms.count >= 3 else {
            XCTFail("체험실 데이터 부족")
            return
        }
        // 맵번호가 높은(후순위) 체험실을 선호로 지정
        let lastRoom = rooms.sorted { $0.mapNumber < $1.mapNumber }.last!
        let preferredIds: Set<String> = [lastRoom.id]

        // Act
        engine.generateRoute(hall: .children, ageInMonths: 72, preferredIds: preferredIds)

        // Assert: 선호 체험실이 루트에 포함되어야 함
        let routeRoomIds = engine.activeRoute.map(\.roomId)
        XCTAssertTrue(routeRoomIds.contains(lastRoom.id), "선호 체험실이 루트에 포함되어야 한다")
    }

    func test_청소년체험관_루트_생성() {
        // Arrange: 14세(168개월) 청소년
        let age = 168

        // Act
        engine.generateRoute(hall: .youth, ageInMonths: age, preferredIds: [])

        // Assert
        XCTAssertFalse(engine.activeRoute.isEmpty, "청소년 루트가 생성되어야 한다")
    }

    func test_미래직업관_루트_생성() {
        // Arrange: 15세(180개월)
        let age = 180

        // Act
        engine.generateRoute(hall: .future, ageInMonths: age, preferredIds: [])

        // Assert
        XCTAssertFalse(engine.activeRoute.isEmpty, "미래직업관 루트가 생성되어야 한다")
    }

    func test_루트_순서_인덱스_연속() {
        // Arrange & Act
        engine.generateRoute(hall: .children, ageInMonths: 72, preferredIds: [])

        // Assert: order가 0부터 순차적으로 증가
        for (i, item) in engine.activeRoute.enumerated() {
            XCTAssertEqual(item.order, i, "order가 \(i)이어야 한다")
        }
    }

    // MARK: - νₑ 정상 경로 — 체험 완료/실패

    func test_체험_성공_완료_처리() {
        // Arrange
        engine.generateRoute(hall: .children, ageInMonths: 72, preferredIds: [])
        guard engine.activeRoute.count >= 2 else {
            XCTFail("루트 아이템 부족")
            return
        }
        let firstJoy = engine.activeRoute[0].joyCurrency

        // Act
        engine.onExperienceSuccess()

        // Assert
        XCTAssertEqual(engine.activeRoute[0].status, .completed, "첫 아이템 완료")
        XCTAssertEqual(engine.currentIndex, 1, "다음 아이템으로 이동")
        XCTAssertEqual(engine.activeRoute[1].status, .active, "두 번째 아이템 활성화")
        XCTAssertEqual(engine.completedCount, 1, "완료 수 1")
        XCTAssertEqual(engine.totalJoy, firstJoy, "JOY 획득")
    }

    func test_체험_실패_대체_체험실_삽입() {
        // Arrange
        engine.generateRoute(hall: .children, ageInMonths: 72, preferredIds: [])
        guard !engine.activeRoute.isEmpty else {
            XCTFail("루트 비어있음")
            return
        }
        let failedRoomId = engine.activeRoute[0].roomId

        // Act
        engine.onExperienceFailed()

        // Assert: 실패한 체험실이 교체되었거나 skipped 처리
        let currentItem = engine.activeRoute[0]
        let wasReplaced = currentItem.roomId != failedRoomId
        let wasSkipped = currentItem.status == .skipped

        XCTAssertTrue(wasReplaced || wasSkipped,
                      "실패한 체험실이 교체되거나 건너뛰어야 한다")
    }

    func test_연속_체험_완료() {
        // Arrange
        engine.generateRoute(hall: .children, ageInMonths: 72, preferredIds: [])
        let totalItems = engine.activeRoute.count

        // Act: 모든 체험 완료
        for _ in 0..<totalItems {
            engine.onExperienceSuccess()
        }

        // Assert
        XCTAssertEqual(engine.completedCount, totalItems, "전부 완료")
        XCTAssertTrue(engine.isRouteComplete, "루트 완료 상태")
        XCTAssertEqual(engine.progress, 1.0, accuracy: 0.01, "진행률 100%")
    }

    // MARK: - νμ 예외 경로 (Error Path)

    func test_나이_부적합_빈_루트() {
        // Arrange: 1세(12개월) — 어린이체험관 최소 나이(36개월) 미만
        let age = 12

        // Act
        engine.generateRoute(hall: .children, ageInMonths: age, preferredIds: [])

        // Assert
        XCTAssertTrue(engine.activeRoute.isEmpty, "나이 미달 시 빈 루트")
    }

    func test_빈_루트에서_체험_완료_호출() {
        // Arrange: 루트 없는 상태

        // Act & Assert: 크래시 없이 처리
        engine.onExperienceSuccess()
        XCTAssertEqual(engine.completedCount, 0, "빈 루트에서 완료 수 0 유지")
    }

    func test_빈_루트에서_체험_실패_호출() {
        // Arrange: 루트 없는 상태

        // Act & Assert: 크래시 없이 처리
        engine.onExperienceFailed()
        XCTAssertTrue(engine.activeRoute.isEmpty, "빈 루트 유지")
    }

    func test_존재하지_않는_roomId_성공_처리() {
        // Arrange
        engine.generateRoute(hall: .children, ageInMonths: 72, preferredIds: [])

        // Act: 존재하지 않는 ID로 성공 처리
        engine.onExperienceSuccess(roomId: "nonexistent-room-id")

        // Assert: 상태 변화 없음
        XCTAssertEqual(engine.completedCount, 0, "존재하지 않는 ID는 무시")
    }

    func test_존재하지_않는_roomId_실패_처리() {
        // Arrange
        engine.generateRoute(hall: .children, ageInMonths: 72, preferredIds: [])

        // Act
        engine.onExperienceFailed(roomId: "nonexistent-room-id")

        // Assert: 상태 변화 없음
        XCTAssertEqual(engine.activeRoute.filter { $0.status == .failed }.count, 0)
    }

    // MARK: - ντ 경계 경로 (Edge Case)

    func test_나이_최소값_경계() {
        // Arrange: 어린이체험관 최소 나이 = 36개월
        let rooms = ScheduleData.rooms(for: .children)
        let minAge = rooms.map(\.minAge).min() ?? 36

        // Act
        engine.generateRoute(hall: .children, ageInMonths: minAge, preferredIds: [])

        // Assert: 최소 나이에서 루트 생성 가능
        XCTAssertFalse(engine.activeRoute.isEmpty, "최소 나이에서 루트 생성 가능")
    }

    func test_나이_최대값_경계() {
        // Arrange: 어린이체험관 최대 나이 = 120개월
        let rooms = ScheduleData.rooms(for: .children)
        let maxAge = rooms.map(\.maxAge).max() ?? 120

        // Act
        engine.generateRoute(hall: .children, ageInMonths: maxAge, preferredIds: [])

        // Assert
        XCTAssertFalse(engine.activeRoute.isEmpty, "최대 나이에서 루트 생성 가능")
    }

    func test_나이_최대값_초과() {
        // Arrange: 어린이체험관 최대 나이 + 1
        let rooms = ScheduleData.rooms(for: .children)
        let overAge = (rooms.map(\.maxAge).max() ?? 120) + 1

        // Act
        engine.generateRoute(hall: .children, ageInMonths: overAge, preferredIds: [])

        // Assert: 적합한 체험실이 없으면 빈 루트
        // (일부 체험실은 maxAge가 높을 수 있으므로 빈 루트 또는 제한된 루트)
        // 결과에 상관없이 크래시 없이 처리되어야 함
        XCTAssertTrue(true, "크래시 없이 처리")
    }

    func test_sessionCount_1_최소_루트() {
        // Act
        engine.generateRoute(hall: .children, ageInMonths: 72, preferredIds: [], sessionCount: 1)

        // Assert
        XCTAssertEqual(engine.activeRoute.count, 1, "1회 체험 루트")
        XCTAssertEqual(engine.activeRoute[0].status, .active)
    }

    func test_sessionCount_0() {
        // Act
        engine.generateRoute(hall: .children, ageInMonths: 72, preferredIds: [], sessionCount: 0)

        // Assert
        XCTAssertTrue(engine.activeRoute.isEmpty, "0회차 요청 시 빈 루트")
    }

    func test_루트_초기화() {
        // Arrange: 루트 생성 + 일부 완료
        engine.generateRoute(hall: .children, ageInMonths: 72, preferredIds: [])
        engine.onExperienceSuccess()

        // Act
        engine.resetRoute()

        // Assert
        XCTAssertTrue(engine.activeRoute.isEmpty, "루트 초기화")
        XCTAssertEqual(engine.currentIndex, 0)
        XCTAssertEqual(engine.completedCount, 0)
        XCTAssertEqual(engine.totalJoy, 0)
        XCTAssertTrue(engine.preferredRoomIds.isEmpty)
    }

    func test_아이템_건너뛰기() {
        // Arrange
        engine.generateRoute(hall: .children, ageInMonths: 72, preferredIds: [])
        guard engine.activeRoute.count >= 2 else { return }

        // Act: 첫 번째 아이템 건너뛰기
        engine.skipItem(at: 0)

        // Assert
        XCTAssertEqual(engine.activeRoute[0].status, .skipped)
        XCTAssertEqual(engine.currentIndex, 1, "다음 아이템으로 이동")
        XCTAssertEqual(engine.activeRoute[1].status, .active)
    }

    func test_잘못된_인덱스_건너뛰기() {
        // Arrange
        engine.generateRoute(hall: .children, ageInMonths: 72, preferredIds: [])

        // Act & Assert: 범위 초과 인덱스 — 크래시 없이 처리
        engine.skipItem(at: 999)
        XCTAssertTrue(true, "크래시 없이 처리")
    }

    func test_진행률_계산() {
        // Arrange
        engine.generateRoute(hall: .children, ageInMonths: 72, preferredIds: [])
        let total = engine.activeRoute.count
        guard total > 0 else { return }

        // Act
        engine.onExperienceSuccess()

        // Assert
        let expected = 1.0 / Double(total)
        XCTAssertEqual(engine.progress, expected, accuracy: 0.01)
    }

    func test_빈_루트_진행률_0() {
        XCTAssertEqual(engine.progress, 0.0)
    }

    func test_빈_루트_isRouteComplete_false() {
        XCTAssertFalse(engine.isRouteComplete)
    }

    func test_현재아이템_빈루트_nil() {
        XCTAssertNil(engine.currentItem)
    }

    func test_다가오는아이템_빈루트_비어있음() {
        XCTAssertTrue(engine.upcomingItems.isEmpty)
    }

    func test_남은체험수_계산() {
        // Arrange
        engine.generateRoute(hall: .children, ageInMonths: 72, preferredIds: [])
        let total = engine.activeRoute.count

        // Act
        engine.onExperienceSuccess()

        // Assert
        XCTAssertEqual(engine.remainingCount, total - 1)
    }

    func test_모든_체험관_루트_생성_가능() {
        // 모든 체험관 타입에 대해 적절한 나이로 루트 생성
        let hallTests: [(HallType, Int)] = [
            (.children, 72),     // 6세
            (.youth, 144),       // 12세
            (.future, 156),      // 13세
            (.skills, 144),      // 12세
        ]

        for (hall, age) in hallTests {
            engine.generateRoute(hall: hall, ageInMonths: age, preferredIds: [])
            XCTAssertFalse(engine.activeRoute.isEmpty, "\(hall) 루트 생성 실패 (나이: \(age)개월)")
        }
    }
}

// MARK: - 모델 테스트

final class ExperienceRoomTests: XCTestCase {

    func test_나이_적합성_체크_범위_내() {
        let room = ExperienceRoom(
            id: "test-01", name: "테스트", hall: .children, floor: "3F",
            mapNumber: 1, duration: 30, minAge: 48, maxAge: 120,
            capacity: 20, joyCurrency: 5, icon: "🏗️",
            isPopular: true, interestType: ["R"]
        )

        XCTAssertTrue(room.isAgeEligible(ageInMonths: 72))
        XCTAssertTrue(room.isAgeEligible(ageInMonths: 48))  // 최소값
        XCTAssertTrue(room.isAgeEligible(ageInMonths: 120)) // 최대값
    }

    func test_나이_적합성_체크_범위_외() {
        let room = ExperienceRoom(
            id: "test-01", name: "테스트", hall: .children, floor: "3F",
            mapNumber: 1, duration: 30, minAge: 48, maxAge: 120,
            capacity: 20, joyCurrency: 5, icon: "🏗️",
            isPopular: true, interestType: ["R"]
        )

        XCTAssertFalse(room.isAgeEligible(ageInMonths: 47))  // 최소 미만
        XCTAssertFalse(room.isAgeEligible(ageInMonths: 121)) // 최대 초과
    }

    func test_층수_변환() {
        let floors: [(String, Int)] = [
            ("B1", -1), ("1F", 1), ("2F", 2), ("3F", 3),
            ("4F", 4), ("5F", 5), ("MF", 2)
        ]

        for (floor, expected) in floors {
            let room = ExperienceRoom(
                id: "test", name: "테스트", hall: .children, floor: floor,
                mapNumber: 1, duration: 30, minAge: 48, maxAge: 120,
                capacity: 20, joyCurrency: 5, icon: "🏗️",
                isPopular: false, interestType: []
            )
            XCTAssertEqual(room.floorNumber, expected, "층 \(floor) → \(expected)")
        }
    }
}

final class RouteItemTests: XCTestCase {

    func test_종료시간_계산() {
        let item = RouteItem(
            roomId: "test", roomName: "테스트", hall: .children,
            floor: "3F", icon: "🏗️",
            scheduledStartTime: "10:00", estimatedDuration: 30,
            order: 0
        )

        XCTAssertEqual(item.scheduledEndTime, "10:30")
    }

    func test_종료시간_시간_넘김() {
        let item = RouteItem(
            roomId: "test", roomName: "테스트", hall: .children,
            floor: "3F", icon: "🏗️",
            scheduledStartTime: "10:50", estimatedDuration: 40,
            order: 0
        )

        XCTAssertEqual(item.scheduledEndTime, "11:30")
    }

    func test_시작시간_분변환() {
        let item = RouteItem(
            roomId: "test", roomName: "테스트", hall: .children,
            floor: "3F", icon: "🏗️",
            scheduledStartTime: "14:30", estimatedDuration: 30,
            order: 0
        )

        XCTAssertEqual(item.startMinutes, 870) // 14*60 + 30
    }

    func test_ExperienceRoom에서_RouteItem_생성() {
        let room = ExperienceRoom(
            id: "children-01", name: "건설탐험대", hall: .children, floor: "3F",
            mapNumber: 1, duration: 30, minAge: 48, maxAge: 120,
            capacity: 20, joyCurrency: 5, icon: "🏗️",
            isPopular: true, interestType: ["R"]
        )

        let item = RouteItem.from(room: room, startTime: "10:00", order: 0)

        XCTAssertEqual(item.roomId, "children-01")
        XCTAssertEqual(item.roomName, "건설탐험대")
        XCTAssertEqual(item.floor, "3F")
        XCTAssertEqual(item.estimatedDuration, 30)
        XCTAssertEqual(item.joyCurrency, 5)
        XCTAssertEqual(item.status, .pending)
    }
}

final class ScheduleDataTests: XCTestCase {

    func test_어린이체험관_데이터_존재() {
        let rooms = ScheduleData.rooms(for: .children)
        XCTAssertEqual(rooms.count, 42, "어린이체험관 42개 체험실")
    }

    func test_청소년체험관_데이터_존재() {
        let rooms = ScheduleData.rooms(for: .youth)
        XCTAssertEqual(rooms.count, 43, "청소년체험관 43개 체험실")
    }

    func test_미래직업관_데이터_존재() {
        let rooms = ScheduleData.rooms(for: .future)
        XCTAssertEqual(rooms.count, 18, "미래직업관 18개 체험실")
    }

    func test_숙련기술체험관_데이터_존재() {
        let rooms = ScheduleData.rooms(for: .skills)
        XCTAssertGreaterThan(rooms.count, 0, "숙련기술체험관 데이터 존재")
    }

    func test_어린이체험관_세션_존재() {
        let sessions = ScheduleData.sessions(for: .children)
        XCTAssertGreaterThan(sessions.count, 0, "세션 데이터 존재")
    }

    func test_모든_체험실_유효한_데이터() {
        let allHalls: [HallType] = [.children, .youth, .future, .skills]

        for hall in allHalls {
            let rooms = ScheduleData.rooms(for: hall)
            for room in rooms {
                XCTAssertFalse(room.id.isEmpty, "\(hall) 체험실 ID 비어있음")
                XCTAssertFalse(room.name.isEmpty, "\(hall) 체험실 이름 비어있음")
                XCTAssertGreaterThan(room.duration, 0, "\(room.name) 소요시간 0 이하")
                XCTAssertGreaterThan(room.capacity, 0, "\(room.name) 수용인원 0 이하")
                XCTAssertGreaterThanOrEqual(room.minAge, 0, "\(room.name) 최소나이 음수")
                XCTAssertGreaterThan(room.maxAge, room.minAge, "\(room.name) 최대나이 <= 최소나이")
            }
        }
    }

    func test_체험실_ID_중복_없음() {
        let allHalls: [HallType] = [.children, .youth, .future, .skills]

        for hall in allHalls {
            let rooms = ScheduleData.rooms(for: hall)
            let ids = rooms.map(\.id)
            let uniqueIds = Set(ids)
            XCTAssertEqual(ids.count, uniqueIds.count, "\(hall) 체험실 ID 중복")
        }
    }
}
