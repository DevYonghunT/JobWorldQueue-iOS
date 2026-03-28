// RouteEngine.swift
// 최적 루트 생성 엔진 — 체험관 유형별 스케줄 방식에 따른 루트 생성

import SwiftUI
import Combine

/// 체험 루트 생성 및 관리 엔진
@MainActor
final class RouteEngine: ObservableObject {
    // MARK: - 게시 상태
    /// 현재 활성 루트
    @Published var activeRoute: [RouteItem] = []
    /// 현재 진행 중인 아이템 인덱스
    @Published var currentIndex: Int = 0
    /// 선택된 체험관
    @Published var selectedHall: HallType = .children
    /// 사용자 나이 (개월)
    @Published var userAgeInMonths: Int = 72
    /// 선호 체험실 ID 목록
    @Published var preferredRoomIds: Set<String> = []
    /// 완료된 체험 수
    @Published var completedCount: Int = 0
    /// 총 획득 JOY
    @Published var totalJoy: Int = 0
    /// 선택된 블록 번호 (어린이체험관: 1부/2부)
    @Published var selectedBlockNumber: Int = 1

    // MARK: - 루트 생성 (통합 진입점)

    /// 사용자 설정 기반으로 최적 루트 생성
    /// - Parameters:
    ///   - hall: 대상 체험관
    ///   - ageInMonths: 사용자 나이 (개월)
    ///   - preferredIds: 선호 체험실 ID (우선 배치)
    ///   - sessionCount: 체험할 회차/체험실 수 (기본값은 유형별 상이)
    ///   - blockNumber: 어린이체험관 블록 번호 (1부 또는 2부, 기본 1)
    func generateRoute(
        hall: HallType,
        ageInMonths: Int,
        preferredIds: Set<String>,
        sessionCount: Int = 5,
        blockNumber: Int = 1
    ) {
        // 0회차 요청 시 빈 루트 반환
        guard sessionCount > 0 else {
            activeRoute = []
            currentIndex = 0
            return
        }

        selectedHall = hall
        userAgeInMonths = ageInMonths
        preferredRoomIds = preferredIds
        selectedBlockNumber = blockNumber

        let scheduleType = ScheduleData.scheduleType(for: hall)

        switch scheduleType {
        case .freeForm:
            generateFreeFormRoute(
                hall: hall,
                ageInMonths: ageInMonths,
                preferredIds: preferredIds,
                maxRooms: sessionCount,
                blockNumber: blockNumber
            )
        case .sessionBased:
            generateSessionBasedRoute(
                hall: hall,
                ageInMonths: ageInMonths,
                preferredIds: preferredIds,
                sessionCount: sessionCount > 0 ? sessionCount : 5
            )
        case .blockBased:
            generateBlockBasedRoute(
                hall: hall,
                ageInMonths: ageInMonths,
                preferredIds: preferredIds
            )
        case .programBased:
            generateProgramBasedRoute(
                hall: hall,
                ageInMonths: ageInMonths,
                preferredIds: preferredIds,
                sessionCount: sessionCount > 0 ? sessionCount : 3
            )
        }

        currentIndex = 0
        completedCount = 0
        totalJoy = 0

        // 첫 아이템 활성화
        if !activeRoute.isEmpty {
            activeRoute[0].status = .active
        }
    }

    // MARK: - 어린이체험관: 자유 체험 루트 생성

    /// 4시간 블록 내에서 체험실별 소요시간 기반 시작 시간 계산 후 최적 순서 생성
    /// - Parameters:
    ///   - hall: 체험관
    ///   - ageInMonths: 나이 (개월)
    ///   - preferredIds: 선호 체험실
    ///   - maxRooms: 최대 체험실 수
    ///   - blockNumber: 1부 또는 2부
    private func generateFreeFormRoute(
        hall: HallType,
        ageInMonths: Int,
        preferredIds: Set<String>,
        maxRooms: Int,
        blockNumber: Int
    ) {
        guard blockNumber >= 1 && blockNumber <= ScheduleData.childrenBlocks.count else {
            activeRoute = []
            return
        }

        let block = ScheduleData.childrenBlocks[blockNumber - 1]
        let availableRooms = ScheduleData.rooms(for: hall)
            .filter { $0.isAgeEligible(ageInMonths: ageInMonths) }

        guard !availableRooms.isEmpty else {
            activeRoute = []
            return
        }

        // 선호 체험실 우선, 인기순 정렬
        let sortedRooms = sortRoomsByPriority(
            rooms: availableRooms,
            preferredIds: preferredIds
        )

        // 블록 시간 내에 들어갈 수 있는 체험실 순서대로 배정
        var route: [RouteItem] = []
        var currentMinute = block.startMinutes
        var roomIndex = 0

        while route.count < maxRooms && roomIndex < sortedRooms.count {
            let room = sortedRooms[roomIndex]
            roomIndex += 1

            // 이 체험실의 소요시간 기준 다음 가능한 시작 시간 계산
            let possibleSlots = block.generateTimeSlots(forDuration: room.duration)
            // 현재 시점 이후의 가장 빠른 슬롯 찾기
            guard let nextSlot = possibleSlots.first(where: { slotTime in
                timeToMinutes(slotTime) >= currentMinute
            }) else {
                continue // 남은 시간에 이 체험실을 넣을 수 없음
            }

            let slotMinute = timeToMinutes(nextSlot)

            // 체험 종료 시간이 블록을 넘지 않는지 확인
            guard slotMinute + room.duration <= block.endMinutes else {
                continue
            }

            let item = RouteItem(
                roomId: room.id,
                roomName: room.name,
                hall: room.hall,
                floor: room.floor,
                icon: room.icon,
                scheduledStartTime: nextSlot,
                estimatedDuration: room.duration,
                order: route.count,
                status: .pending,
                joyCurrency: room.joyCurrency
            )
            route.append(item)

            // 다음 체험 시작 가능 시점 = 현재 체험 종료 + 이동시간
            currentMinute = slotMinute + room.duration + block.transitionMinutes
        }

        // 층 이동 최적화 적용
        activeRoute = optimizeFloorTransitionsForFreeForm(route: route, block: block)
    }

    // MARK: - 청소년/미래직업관: 회차 기반 루트 생성

    /// 정해진 회차(5부)에 1개 체험실씩 배정
    /// - Parameters:
    ///   - hall: 체험관
    ///   - ageInMonths: 나이 (개월)
    ///   - preferredIds: 선호 체험실
    ///   - sessionCount: 체험할 회차 수
    private func generateSessionBasedRoute(
        hall: HallType,
        ageInMonths: Int,
        preferredIds: Set<String>,
        sessionCount: Int
    ) {
        let availableRooms = ScheduleData.rooms(for: hall)
            .filter { $0.isAgeEligible(ageInMonths: ageInMonths) }

        guard !availableRooms.isEmpty else {
            activeRoute = []
            return
        }

        let sessions = ScheduleData.sessions(for: hall)
        guard !sessions.isEmpty else {
            activeRoute = []
            return
        }

        // 선호 체험실 우선, 인기순 정렬
        let sortedRooms = sortRoomsByPriority(
            rooms: availableRooms,
            preferredIds: preferredIds
        )

        // 회차별로 1개 체험실 배정
        var route: [RouteItem] = []
        let maxItems = min(sessionCount, sessions.count, sortedRooms.count)

        for i in 0..<maxItems {
            let room = sortedRooms[i]
            let session = sessions[i]
            let item = RouteItem(
                roomId: room.id,
                roomName: room.name,
                hall: room.hall,
                floor: room.floor,
                icon: room.icon,
                scheduledStartTime: session.startTime,
                estimatedDuration: room.duration,
                order: i,
                status: .pending,
                joyCurrency: room.joyCurrency
            )
            route.append(item)
        }

        // 층 이동 최소화 최적화 (시간 슬롯은 고정, 체험실만 교환)
        activeRoute = optimizeFloorTransitions(route: route)
    }

    // MARK: - 숙련기술체험관: 블록 기반 루트 생성

    /// 2시간 블록당 1개 체험실 배정 (1부 사전예약 필수)
    /// - Parameters:
    ///   - hall: 체험관
    ///   - ageInMonths: 나이 (개월)
    ///   - preferredIds: 선호 체험실
    private func generateBlockBasedRoute(
        hall: HallType,
        ageInMonths: Int,
        preferredIds: Set<String>
    ) {
        let availableRooms = ScheduleData.rooms(for: hall)
            .filter { $0.isAgeEligible(ageInMonths: ageInMonths) }

        guard !availableRooms.isEmpty else {
            activeRoute = []
            return
        }

        let sessions = ScheduleData.sessions(for: hall)
        guard !sessions.isEmpty else {
            activeRoute = []
            return
        }

        // 선호 체험실 우선 정렬
        let sortedRooms = sortRoomsByPriority(
            rooms: availableRooms,
            preferredIds: preferredIds
        )

        // 블록당 1개 체험실 배정 (최대 2블록)
        var route: [RouteItem] = []
        let maxBlocks = min(sessions.count, sortedRooms.count)

        for i in 0..<maxBlocks {
            let room = sortedRooms[i]
            let session = sessions[i]
            let item = RouteItem(
                roomId: room.id,
                roomName: room.name,
                hall: room.hall,
                floor: room.floor,
                icon: room.icon,
                scheduledStartTime: session.startTime,
                estimatedDuration: room.duration,
                order: i,
                status: .pending,
                joyCurrency: room.joyCurrency
            )
            route.append(item)
        }

        activeRoute = route
    }

    // MARK: - 진로설계관/메카이브: 프로그램 기반 루트 생성

    /// 프로그램 단위 배정
    private func generateProgramBasedRoute(
        hall: HallType,
        ageInMonths: Int,
        preferredIds: Set<String>,
        sessionCount: Int
    ) {
        let availableRooms = ScheduleData.rooms(for: hall)
            .filter { $0.isAgeEligible(ageInMonths: ageInMonths) }

        guard !availableRooms.isEmpty else {
            activeRoute = []
            return
        }

        let sessions = ScheduleData.sessions(for: hall)
        guard !sessions.isEmpty else {
            activeRoute = []
            return
        }

        // 선호 프로그램 우선 정렬
        let sortedRooms = sortRoomsByPriority(
            rooms: availableRooms,
            preferredIds: preferredIds
        )

        // 가능한 세션 수만큼 배정
        var route: [RouteItem] = []
        let maxItems = min(sessionCount, sessions.count, sortedRooms.count)

        for i in 0..<maxItems {
            let room = sortedRooms[i]
            let session = sessions[i]
            let item = RouteItem(
                roomId: room.id,
                roomName: room.name,
                hall: room.hall,
                floor: room.floor,
                icon: room.icon,
                scheduledStartTime: session.startTime,
                estimatedDuration: room.duration,
                order: i,
                status: .pending,
                joyCurrency: room.joyCurrency
            )
            route.append(item)
        }

        activeRoute = route
    }

    // MARK: - 체험실 우선순위 정렬

    /// 선호도, 인기도, 맵 번호를 고려한 체험실 정렬
    private func sortRoomsByPriority(
        rooms: [ExperienceRoom],
        preferredIds: Set<String>
    ) -> [ExperienceRoom] {
        return rooms.sorted { a, b in
            // 1순위: 선호 체험실
            let aPreferred = preferredIds.contains(a.id)
            let bPreferred = preferredIds.contains(b.id)
            if aPreferred != bPreferred {
                return aPreferred
            }

            // 2순위: 인기 체험실
            if a.isPopular != b.isPopular {
                return a.isPopular
            }

            // 3순위: 맵 번호순
            return a.mapNumber < b.mapNumber
        }
    }

    // MARK: - 자유 체험 층 이동 최적화

    /// 자유 체험 모드에서 시간 슬롯 재계산을 포함한 층 이동 최적화
    private func optimizeFloorTransitionsForFreeForm(
        route: [RouteItem],
        block: FreeFormBlock
    ) -> [RouteItem] {
        guard route.count > 2 else { return route }

        // 같은 층끼리 묶어서 연속 배치 (그리디 방식)
        var optimized = route
        for i in 1..<optimized.count {
            let currentFloor = optimized[i - 1].floor
            var bestSwapIndex = i

            for j in (i + 1)..<optimized.count {
                if optimized[j].floor == currentFloor {
                    bestSwapIndex = j
                    break
                }
            }

            if bestSwapIndex != i {
                optimized.swapAt(i, bestSwapIndex)
            }
        }

        // 시간 슬롯 재계산 — 최적화된 순서에 맞춰 시작 시간 재배정
        var currentMinute = block.startMinutes
        for i in 0..<optimized.count {
            let duration = optimized[i].estimatedDuration
            // 이 소요시간의 가능한 슬롯 중 현재 시점 이후 가장 빠른 것
            let possibleSlots = block.generateTimeSlots(forDuration: duration)
            if let nextSlot = possibleSlots.first(where: { timeToMinutes($0) >= currentMinute }) {
                optimized[i].scheduledStartTime = nextSlot
                currentMinute = timeToMinutes(nextSlot) + duration + block.transitionMinutes
            }
            optimized[i].order = i
        }

        return optimized
    }

    // MARK: - 회차 기반 층 이동 최적화

    /// 인접 아이템 간 층 이동을 최소화하도록 재배치 (시간 슬롯은 유지)
    private func optimizeFloorTransitions(route: [RouteItem]) -> [RouteItem] {
        guard route.count > 2 else { return route }

        var optimized = route
        let middleRange = 1..<(route.count - 1)

        // 간단한 그리디 최적화: 현재 층과 같은 층 우선
        for i in middleRange {
            let currentFloor = optimized[i - 1].floor
            var bestSwapIndex = i

            for j in (i + 1)..<optimized.count {
                if optimized[j].floor == currentFloor {
                    bestSwapIndex = j
                    break
                }
            }

            if bestSwapIndex != i {
                // 시간은 유지하면서 체험실만 교환
                let tempStartTime = optimized[i].scheduledStartTime
                optimized[i].scheduledStartTime = optimized[bestSwapIndex].scheduledStartTime
                optimized[bestSwapIndex].scheduledStartTime = tempStartTime
                optimized.swapAt(i, bestSwapIndex)
            }
        }

        // 순서 인덱스 재정렬
        for i in 0..<optimized.count {
            optimized[i].order = i
        }

        return optimized
    }

    // MARK: - 시간 유틸리티

    /// "HH:mm" 문자열을 분 단위 정수로 변환
    private func timeToMinutes(_ time: String) -> Int {
        let parts = time.split(separator: ":").compactMap { Int($0) }
        guard parts.count == 2 else { return 0 }
        return parts[0] * 60 + parts[1]
    }

    /// 분 단위 정수를 "HH:mm" 문자열로 변환
    private func minutesToTime(_ minutes: Int) -> String {
        let h = minutes / 60
        let m = minutes % 60
        return String(format: "%02d:%02d", h, m)
    }

    // MARK: - 현재 진행 아이템

    /// 현재 활성 상태의 아이템 반환
    var currentItem: RouteItem? {
        guard currentIndex < activeRoute.count else { return nil }
        return activeRoute[currentIndex]
    }

    /// 다음 대기 중인 아이템 목록 (최대 3개)
    var upcomingItems: [RouteItem] {
        let startIndex = currentIndex + 1
        guard startIndex < activeRoute.count else { return [] }
        let endIndex = min(startIndex + 3, activeRoute.count)
        return Array(activeRoute[startIndex..<endIndex])
    }

    /// 전체 루트 진행률 (0.0 ~ 1.0)
    var progress: Double {
        guard !activeRoute.isEmpty else { return 0 }
        return Double(completedCount) / Double(activeRoute.count)
    }
}
