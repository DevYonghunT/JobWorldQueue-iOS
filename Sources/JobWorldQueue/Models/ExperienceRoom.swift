// ExperienceRoom.swift
// 체험실 모델 — 잡월드 각 체험관의 개별 체험실 정보

import Foundation

struct ExperienceRoom: Identifiable, Codable, Hashable {
    /// 고유 식별자 (예: "children-01")
    let id: String
    /// 체험실 이름 (예: "건설탐험대")
    let name: String
    /// 소속 체험관
    let hall: HallType
    /// 위치 층수 (예: "3F", "MF")
    let floor: String
    /// 리플렛 번호 (예: 01)
    let mapNumber: Int
    /// 체험 소요 시간 (분)
    let duration: Int
    /// 최소 이용 가능 나이 (개월)
    let minAge: Int
    /// 최대 이용 가능 나이 (개월)
    let maxAge: Int
    /// 회당 수용 인원
    let capacity: Int
    /// 획득/사용 JOY 화폐
    let joyCurrency: Int
    /// 아이콘 이모지
    let icon: String
    /// 인기 체험실 여부
    let isPopular: Bool
    /// RIASEC 흥미 유형 (Realistic, Investigative, Artistic, Social, Enterprising, Conventional)
    let interestType: [String]

    /// 나이(개월)가 이용 가능 범위에 해당하는지 확인
    func isAgeEligible(ageInMonths: Int) -> Bool {
        return ageInMonths >= minAge && ageInMonths <= maxAge
    }

    /// 층수를 정수로 변환 (루트 최적화에 사용)
    var floorNumber: Int {
        switch floor {
        case "B1": return -1
        case "1F": return 1
        case "2F": return 2
        case "3F": return 3
        case "4F": return 4
        case "5F": return 5
        case "MF": return 2  // 중층은 2층으로 취급
        default: return 1
        }
    }
}
