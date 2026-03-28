// Hall.swift
// 체험관 모델 — 잡월드 체험관 유형 정의

import SwiftUI

/// 잡월드 체험관 유형
enum HallType: String, CaseIterable, Codable, Hashable {
    case children = "어린이체험관"
    case youth = "청소년체험관"
    case future = "미래직업관"
    case skills = "숙련기술체험관"
    case career = "진로설계관"
    case makers = "메카이브"

    /// 체험관 표시 이름
    var displayName: String {
        return rawValue
    }

    /// 체험관 짧은 이름
    var shortName: String {
        switch self {
        case .children: return "어린이"
        case .youth: return "청소년"
        case .future: return "미래직업"
        case .skills: return "숙련기술"
        case .career: return "진로설계"
        case .makers: return "메카이브"
        }
    }

    /// 체험관 대표 아이콘
    var icon: String {
        switch self {
        case .children: return "figure.child"
        case .youth: return "figure.wave"
        case .future: return "sparkles"
        case .skills: return "wrench.and.screwdriver.fill"
        case .career: return "compass.drawing"
        case .makers: return "hammer.fill"
        }
    }

    /// 체험관 대표 이모지
    var emoji: String {
        switch self {
        case .children: return "🧒"
        case .youth: return "🧑‍🎓"
        case .future: return "🚀"
        case .skills: return "🔧"
        case .career: return "🧭"
        case .makers: return "🔨"
        }
    }

    /// 체험관 테마 색상
    var themeColor: Color {
        switch self {
        case .children: return AppTheme.childrenColor
        case .youth: return AppTheme.youthColor
        case .future: return AppTheme.futureColor
        case .skills: return AppTheme.skillsColor
        case .career: return Color(hex: "#9B59B6")
        case .makers: return Color(hex: "#E74C3C")
        }
    }

    /// 체험관 설명
    var description: String {
        switch self {
        case .children: return "만 3세~초등 저학년 대상 42개 체험실"
        case .youth: return "초등 고학년~중학생 대상 43개 체험실"
        case .future: return "첨단 미래 직업 체험 18개 체험실"
        case .skills: return "숙련 기술 체험 19개 체험실"
        case .career: return "진로 설계 및 상담"
        case .makers: return "메이커 스페이스 활동"
        }
    }

    /// 해당 체험관의 연령 범위 (개월)
    var ageRange: ClosedRange<Int> {
        switch self {
        case .children: return 36...120      // 3세~10세
        case .youth: return 108...192        // 9세~16세
        case .future: return 120...216       // 10세~18세
        case .skills: return 120...216       // 10세~18세
        case .career: return 120...216       // 10세~18세
        case .makers: return 84...216        // 7세~18세
        }
    }
}

/// 체험관 정보를 담는 구조체
struct Hall: Identifiable {
    let id: HallType
    let rooms: [ExperienceRoom]

    var name: String { id.displayName }
    var roomCount: Int { rooms.count }
}
