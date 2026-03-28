// Course.swift
// 코스/루트 모델 — 사용자가 선택한 체험 루트 정보

import Foundation

/// 체험 루트/코스
struct Course: Identifiable, Codable {
    let id: UUID
    /// 코스 이름
    let name: String
    /// 대상 체험관
    let hall: HallType
    /// 루트 아이템 목록 (순서대로)
    var items: [RouteItem]
    /// 코스 생성 일시
    let createdAt: Date
    /// 총 예상 소요 시간 (분)
    var totalDuration: Int {
        items.reduce(0) { $0 + $1.estimatedDuration }
    }
    /// 완료된 체험 수
    var completedCount: Int {
        items.filter { $0.status == .completed }.count
    }
    /// 진행률 (0.0 ~ 1.0)
    var progress: Double {
        guard !items.isEmpty else { return 0 }
        return Double(completedCount) / Double(items.count)
    }

    init(
        id: UUID = UUID(),
        name: String,
        hall: HallType,
        items: [RouteItem],
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.hall = hall
        self.items = items
        self.createdAt = createdAt
    }
}

/// 코스 프리셋 유형
enum CoursePreset: String, CaseIterable {
    case popular = "인기 체험"
    case science = "과학 탐구"
    case arts = "예술 창작"
    case safety = "안전 체험"
    case food = "음식 만들기"
    case technology = "기술 체험"

    var description: String {
        switch self {
        case .popular: return "가장 인기 있는 체험실 위주"
        case .science: return "과학·연구 관련 체험실"
        case .arts: return "예술·디자인 관련 체험실"
        case .safety: return "안전·구조 관련 체험실"
        case .food: return "요리·음식 관련 체험실"
        case .technology: return "기술·IT 관련 체험실"
        }
    }

    var icon: String {
        switch self {
        case .popular: return "star.fill"
        case .science: return "atom"
        case .arts: return "paintpalette.fill"
        case .safety: return "shield.checkered"
        case .food: return "fork.knife"
        case .technology: return "cpu"
        }
    }

    /// RIASEC 흥미 유형 매핑
    var riasecTypes: [String] {
        switch self {
        case .popular: return []
        case .science: return ["I", "R"]
        case .arts: return ["A"]
        case .safety: return ["R", "S"]
        case .food: return ["R", "A"]
        case .technology: return ["R", "I"]
        }
    }
}
