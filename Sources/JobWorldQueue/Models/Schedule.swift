// Schedule.swift
// 시간표 모델 — 체험관별 운영 시간 및 회차 정보

import Foundation

/// 스케줄 유형 — 체험관마다 운영 방식이 다름
enum ScheduleType: String, Codable, Hashable {
    /// 자유 체험: 4시간 블록 내에서 체험실별 소요시간에 따라 시작 시간 자동 생성 (어린이체험관)
    case freeForm = "자유체험"
    /// 회차 기반: 정해진 시간에 1개 체험실 진행 (청소년/미래직업관)
    case sessionBased = "회차기반"
    /// 블록 기반: 2시간 블록에서 1개 체험실 사전예약 (숙련기술체험관)
    case blockBased = "블록기반"
    /// 프로그램 기반: 별도 프로그램 단위로 운영 (진로설계관/메카이브)
    case programBased = "프로그램기반"
}

/// 하루 운영 시간표
struct Schedule: Identifiable, Codable {
    let id: UUID
    /// 대상 체험관
    let hall: HallType
    /// 운영 요일 (1=일, 2=월, ..., 7=토)
    let dayOfWeek: Set<Int>
    /// 회차 시간표
    let sessions: [SessionTime]
    /// 스케줄 유형
    let scheduleType: ScheduleType

    init(
        id: UUID = UUID(),
        hall: HallType,
        dayOfWeek: Set<Int>,
        sessions: [SessionTime],
        scheduleType: ScheduleType = .sessionBased
    ) {
        self.id = id
        self.hall = hall
        self.dayOfWeek = dayOfWeek
        self.sessions = sessions
        self.scheduleType = scheduleType
    }
}

/// 자유 체험 블록 — 어린이체험관용 시간대 (1부/2부)
struct FreeFormBlock: Identifiable, Codable, Hashable {
    let id: UUID
    /// 블록 번호 (1부, 2부)
    let blockNumber: Int
    /// 블록 시작 시간 (HH:mm)
    let startTime: String
    /// 블록 종료 시간 (HH:mm)
    let endTime: String
    /// 이동 시간 (분) — 체험실 간 이동에 소요되는 버퍼
    let transitionMinutes: Int

    init(
        id: UUID = UUID(),
        blockNumber: Int,
        startTime: String,
        endTime: String,
        transitionMinutes: Int = 5
    ) {
        self.id = id
        self.blockNumber = blockNumber
        self.startTime = startTime
        self.endTime = endTime
        self.transitionMinutes = transitionMinutes
    }

    /// 시작 시간을 분 단위로 변환
    var startMinutes: Int {
        timeToMinutes(startTime)
    }

    /// 종료 시간을 분 단위로 변환
    var endMinutes: Int {
        timeToMinutes(endTime)
    }

    /// 블록 총 시간 (분)
    var durationMinutes: Int {
        endMinutes - startMinutes
    }

    /// 특정 소요시간의 체험실이 이 블록 내에서 시작할 수 있는 시간 목록 생성
    /// - Parameter roomDuration: 체험 소요시간 (분)
    /// - Returns: 가능한 시작 시간 배열 (HH:mm)
    func generateTimeSlots(forDuration roomDuration: Int) -> [String] {
        var slots: [String] = []
        var currentMinute = startMinutes

        // 체험 소요시간 + 이동 시간 간격으로 슬롯 생성
        let interval = roomDuration + transitionMinutes
        while currentMinute + roomDuration <= endMinutes {
            slots.append(minutesToTime(currentMinute))
            currentMinute += interval
        }

        return slots
    }

    /// 분 → "HH:mm" 변환 헬퍼
    private func minutesToTime(_ minutes: Int) -> String {
        let h = minutes / 60
        let m = minutes % 60
        return String(format: "%02d:%02d", h, m)
    }

    /// "HH:mm" → 분 변환 헬퍼
    private func timeToMinutes(_ time: String) -> Int {
        let parts = time.split(separator: ":").compactMap { Int($0) }
        guard parts.count == 2 else { return 0 }
        return parts[0] * 60 + parts[1]
    }
}

/// 개별 회차 시간
struct SessionTime: Identifiable, Codable, Hashable {
    let id: UUID
    /// 회차 번호
    let sessionNumber: Int
    /// 시작 시간 (HH:mm 형식)
    let startTime: String
    /// 종료 시간 (HH:mm 형식)
    let endTime: String

    init(
        id: UUID = UUID(),
        sessionNumber: Int,
        startTime: String,
        endTime: String
    ) {
        self.id = id
        self.sessionNumber = sessionNumber
        self.startTime = startTime
        self.endTime = endTime
    }

    /// 시작 시간을 분 단위로 변환 (00:00 기준)
    var startMinutes: Int {
        let parts = startTime.split(separator: ":").compactMap { Int($0) }
        guard parts.count == 2 else { return 0 }
        return parts[0] * 60 + parts[1]
    }

    /// 종료 시간을 분 단위로 변환
    var endMinutes: Int {
        let parts = endTime.split(separator: ":").compactMap { Int($0) }
        guard parts.count == 2 else { return 0 }
        return parts[0] * 60 + parts[1]
    }

    /// 회차 소요 시간 (분)
    var durationMinutes: Int {
        return endMinutes - startMinutes
    }
}

/// 특정 체험실의 특정 회차 예약 가능 상태
struct RoomSession: Identifiable {
    let id: UUID
    let room: ExperienceRoom
    let session: SessionTime
    var availableSlots: Int
    var isAvailable: Bool { availableSlots > 0 }

    init(
        id: UUID = UUID(),
        room: ExperienceRoom,
        session: SessionTime,
        availableSlots: Int
    ) {
        self.id = id
        self.room = room
        self.session = session
        self.availableSlots = availableSlots
    }
}
