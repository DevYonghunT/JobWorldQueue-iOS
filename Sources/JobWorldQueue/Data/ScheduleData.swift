// ScheduleData.swift
// 시간표 데이터 — 체험관별 운영 회차 정보 (실제 잡월드 운영 시간 기준)

import Foundation

/// 잡월드 체험관 시간표 데이터
enum ScheduleData {

    // MARK: - 어린이체험관 (자유체험 2부제, 4시간 블록)

    /// 어린이체험관 자유 체험 블록 (1부/2부)
    static let childrenBlocks: [FreeFormBlock] = [
        FreeFormBlock(blockNumber: 1, startTime: "09:30", endTime: "13:30", transitionMinutes: 5),
        FreeFormBlock(blockNumber: 2, startTime: "14:30", endTime: "18:30", transitionMinutes: 5),
    ]

    /// 조이숍 운영 시간 (어린이체험관 내)
    static let joyShopSessions: [SessionTime] = [
        SessionTime(sessionNumber: 1, startTime: "10:30", endTime: "13:30"),
        SessionTime(sessionNumber: 2, startTime: "15:30", endTime: "18:30"),
    ]

    /// 은행출장소 운영 시간 (어린이체험관 내)
    static let bankSessions: [SessionTime] = [
        SessionTime(sessionNumber: 1, startTime: "12:30", endTime: "13:30"),
        SessionTime(sessionNumber: 2, startTime: "17:30", endTime: "18:30"),
    ]

    /// 어린이체험관 소요시간별 시작 시간 생성
    /// - Parameters:
    ///   - duration: 체험 소요시간 (분)
    ///   - blockNumber: 부 번호 (1 또는 2)
    /// - Returns: 가능한 시작 시간 배열
    static func childrenTimeSlots(forDuration duration: Int, block blockNumber: Int) -> [String] {
        guard blockNumber >= 1 && blockNumber <= childrenBlocks.count else { return [] }
        let block = childrenBlocks[blockNumber - 1]
        return block.generateTimeSlots(forDuration: duration)
    }

    /// 어린이체험관에서 사용되는 체험 소요시간 종류 (분)
    static let childrenDurations: [Int] = [15, 20, 25, 30, 35, 40]

    /// 소요시간별 전체 시간표 (1부 + 2부)
    /// - Parameter duration: 체험 소요시간 (분)
    /// - Returns: 전체 시작 시간 배열
    static func allChildrenTimeSlots(forDuration duration: Int) -> [String] {
        var allSlots: [String] = []
        for block in childrenBlocks {
            allSlots.append(contentsOf: block.generateTimeSlots(forDuration: duration))
        }
        return allSlots
    }

    // MARK: - 청소년체험관 (5부제, 각 약 60분)

    static let youthSessions: [SessionTime] = [
        SessionTime(sessionNumber: 1, startTime: "10:00", endTime: "11:00"),
        SessionTime(sessionNumber: 2, startTime: "11:20", endTime: "12:20"),
        SessionTime(sessionNumber: 3, startTime: "13:20", endTime: "14:20"),
        SessionTime(sessionNumber: 4, startTime: "14:40", endTime: "15:40"),
        SessionTime(sessionNumber: 5, startTime: "16:00", endTime: "17:00"),
    ]

    // MARK: - 미래직업관 (5회/일, 각 약 60분, 자유체험 방식)

    static let futureSessions: [SessionTime] = [
        SessionTime(sessionNumber: 1, startTime: "10:00", endTime: "11:00"),
        SessionTime(sessionNumber: 2, startTime: "11:20", endTime: "12:20"),
        SessionTime(sessionNumber: 3, startTime: "13:40", endTime: "14:40"),
        SessionTime(sessionNumber: 4, startTime: "15:00", endTime: "16:00"),
        SessionTime(sessionNumber: 5, startTime: "16:20", endTime: "17:20"),
    ]

    // MARK: - 숙련기술체험관 (2시간/회, 2부제, 평일만 운영)

    static let skillsSessions: [SessionTime] = [
        SessionTime(sessionNumber: 1, startTime: "10:00", endTime: "12:00"),
        SessionTime(sessionNumber: 2, startTime: "13:00", endTime: "15:00"),
    ]

    /// 숙련기술체험관 운영 요일 (화~금 = 3,4,5,6, 토·일 휴관)
    static let skillsOperatingDays: Set<Int> = [3, 4, 5, 6]

    // MARK: - 진로설계관 (5부제)

    static let careerSessions: [SessionTime] = [
        SessionTime(sessionNumber: 1, startTime: "09:10", endTime: "10:40"),
        SessionTime(sessionNumber: 2, startTime: "10:50", endTime: "12:20"),
        SessionTime(sessionNumber: 3, startTime: "12:40", endTime: "14:10"),
        SessionTime(sessionNumber: 4, startTime: "14:20", endTime: "15:50"),
        SessionTime(sessionNumber: 5, startTime: "16:00", endTime: "17:20"),
    ]

    // MARK: - 메카이브

    /// K.ground (4F) — 90분 또는 50분 체험, 6회/일
    static let makersKGroundSessions: [SessionTime] = [
        SessionTime(sessionNumber: 1, startTime: "10:00", endTime: "11:30"),
        SessionTime(sessionNumber: 2, startTime: "11:40", endTime: "13:10"),
        SessionTime(sessionNumber: 3, startTime: "13:20", endTime: "14:50"),
        SessionTime(sessionNumber: 4, startTime: "15:00", endTime: "16:30"),
        SessionTime(sessionNumber: 5, startTime: "16:40", endTime: "17:30"),
        SessionTime(sessionNumber: 6, startTime: "17:40", endTime: "18:30"),
    ]

    /// M.street (5F) — 별도 프로그램
    static let makersMStreetSessions: [SessionTime] = [
        SessionTime(sessionNumber: 1, startTime: "10:00", endTime: "12:00"),
        SessionTime(sessionNumber: 2, startTime: "13:00", endTime: "15:00"),
        SessionTime(sessionNumber: 3, startTime: "15:30", endTime: "17:30"),
    ]

    // MARK: - 스케줄 유형 조회

    /// 체험관별 스케줄 유형 반환
    static func scheduleType(for hall: HallType) -> ScheduleType {
        switch hall {
        case .children: return .freeForm
        case .youth: return .sessionBased
        case .future: return .sessionBased
        case .skills: return .blockBased
        case .career: return .programBased
        case .makers: return .programBased
        }
    }

    // MARK: - 체험관별 세션 조회

    /// 체험관별 시간표 조회
    static func sessions(for hall: HallType) -> [SessionTime] {
        switch hall {
        case .children:
            // 어린이체험관은 자유 체험이므로 블록 단위 세션 반환
            return childrenBlocks.map { block in
                SessionTime(
                    sessionNumber: block.blockNumber,
                    startTime: block.startTime,
                    endTime: block.endTime
                )
            }
        case .youth: return youthSessions
        case .future: return futureSessions
        case .skills: return skillsSessions
        case .career: return careerSessions
        case .makers: return makersKGroundSessions
        }
    }

    // MARK: - 체험실 조회

    /// 특정 체험관의 전체 체험실 조회
    static func rooms(for hall: HallType) -> [ExperienceRoom] {
        switch hall {
        case .children: return ChildrenHallData.rooms
        case .youth: return YouthHallData.rooms
        case .future: return FutureHallData.rooms
        case .skills: return SkillsHallData.rooms
        case .career: return CareerHallData.rooms
        case .makers: return MakersHallData.rooms
        }
    }

    /// 전체 체험실 목록
    static var allRooms: [ExperienceRoom] {
        ChildrenHallData.rooms
            + YouthHallData.rooms
            + FutureHallData.rooms
            + SkillsHallData.rooms
            + CareerHallData.rooms
            + MakersHallData.rooms
    }

    // MARK: - 운영일 확인

    /// 일반 운영 요일 (화~일 = 3~7, 1) — 월요일(2) 휴관
    static let operatingDays: Set<Int> = [1, 3, 4, 5, 6, 7]

    /// 오늘이 운영일인지 확인
    static var isTodayOperating: Bool {
        let weekday = Calendar.current.component(.weekday, from: Date())
        return operatingDays.contains(weekday)
    }

    /// 특정 체험관이 오늘 운영하는지 확인
    static func isOperatingToday(hall: HallType) -> Bool {
        let weekday = Calendar.current.component(.weekday, from: Date())

        switch hall {
        case .skills:
            // 숙련기술체험관은 평일만 (화~금)
            return skillsOperatingDays.contains(weekday)
        default:
            return operatingDays.contains(weekday)
        }
    }

    /// 현재 시간 기준 다음 가능한 회차 반환
    static func nextAvailableSession(for hall: HallType) -> SessionTime? {
        let now = Date()
        let calendar = Calendar.current
        let currentMinutes = calendar.component(.hour, from: now) * 60 + calendar.component(.minute, from: now)

        let hallSessions = sessions(for: hall)
        return hallSessions.first { $0.startMinutes > currentMinutes }
    }

    /// 현재 진행 중인 어린이체험관 블록 번호 (없으면 nil)
    static func currentChildrenBlock() -> Int? {
        let now = Date()
        let calendar = Calendar.current
        let currentMinutes = calendar.component(.hour, from: now) * 60 + calendar.component(.minute, from: now)

        for block in childrenBlocks {
            if currentMinutes >= block.startMinutes && currentMinutes < block.endMinutes {
                return block.blockNumber
            }
        }
        return nil
    }
}
