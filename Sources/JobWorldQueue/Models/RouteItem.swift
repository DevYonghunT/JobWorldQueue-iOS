// RouteItem.swift
// 루트 아이템 모델 — 루트 내 개별 체험 항목

import Foundation

/// 루트 내 개별 체험 아이템
struct RouteItem: Identifiable, Codable, Hashable {
    let id: UUID
    /// 체험실 ID
    let roomId: String
    /// 체험실 이름
    let roomName: String
    /// 소속 체험관
    let hall: HallType
    /// 위치 층수
    let floor: String
    /// 아이콘 이모지
    let icon: String
    /// 예상 시작 시간 (HH:mm)
    var scheduledStartTime: String
    /// 예상 체험 시간 (분)
    let estimatedDuration: Int
    /// 루트 내 순서
    var order: Int
    /// 상태
    var status: RouteItemStatus
    /// JOY 화폐
    let joyCurrency: Int

    init(
        id: UUID = UUID(),
        roomId: String,
        roomName: String,
        hall: HallType,
        floor: String,
        icon: String,
        scheduledStartTime: String,
        estimatedDuration: Int,
        order: Int,
        status: RouteItemStatus = .pending,
        joyCurrency: Int = 0
    ) {
        self.id = id
        self.roomId = roomId
        self.roomName = roomName
        self.hall = hall
        self.floor = floor
        self.icon = icon
        self.scheduledStartTime = scheduledStartTime
        self.estimatedDuration = estimatedDuration
        self.order = order
        self.status = status
        self.joyCurrency = joyCurrency
    }

    /// 예상 종료 시간 계산
    var scheduledEndTime: String {
        let parts = scheduledStartTime.split(separator: ":").compactMap { Int($0) }
        guard parts.count == 2 else { return scheduledStartTime }
        let totalMinutes = parts[0] * 60 + parts[1] + estimatedDuration
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        return String(format: "%02d:%02d", hours, minutes)
    }

    /// 시작 시간을 분 단위로 변환
    var startMinutes: Int {
        let parts = scheduledStartTime.split(separator: ":").compactMap { Int($0) }
        guard parts.count == 2 else { return 0 }
        return parts[0] * 60 + parts[1]
    }

    /// ExperienceRoom에서 RouteItem 생성 헬퍼
    static func from(
        room: ExperienceRoom,
        startTime: String,
        order: Int
    ) -> RouteItem {
        RouteItem(
            roomId: room.id,
            roomName: room.name,
            hall: room.hall,
            floor: room.floor,
            icon: room.icon,
            scheduledStartTime: startTime,
            estimatedDuration: room.duration,
            order: order,
            joyCurrency: room.joyCurrency
        )
    }
}

/// 루트 아이템 상태
enum RouteItemStatus: String, Codable, Hashable {
    case pending = "대기"
    case active = "진행중"
    case completed = "완료"
    case skipped = "건너뜀"
    case failed = "실패"

    var displayColor: String {
        switch self {
        case .pending: return "#636E72"
        case .active: return "#FF6B6B"
        case .completed: return "#2ECC71"
        case .skipped: return "#F39C12"
        case .failed: return "#E74C3C"
        }
    }
}
