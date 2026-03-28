// MakersHallData.swift
// 메카이브 데이터 — 만4세~성인 대상 메이커 스페이스

import Foundation

/// 메카이브 데이터 (만4세~성인)
enum MakersHallData {

    /// 대상 연령 설명
    static let targetAgeDescription = "만 4세 ~ 성인"

    /// 메카이브 전체 체험 프로그램
    static let rooms: [ExperienceRoom] = [

        // MARK: - K.ground (4F) — 90분/50분 체험

        ExperienceRoom(
            id: "makers-01", name: "K.ground 창작공방A", hall: .makers, floor: "4F", mapNumber: 1,
            duration: 90, minAge: 48, maxAge: 780, capacity: 20, joyCurrency: 0,
            icon: "🔨", isPopular: true, interestType: ["R", "A"]
        ),
        ExperienceRoom(
            id: "makers-02", name: "K.ground 창작공방B", hall: .makers, floor: "4F", mapNumber: 2,
            duration: 90, minAge: 48, maxAge: 780, capacity: 20, joyCurrency: 0,
            icon: "🔨", isPopular: true, interestType: ["R", "A"]
        ),
        ExperienceRoom(
            id: "makers-03", name: "K.ground 미니체험A", hall: .makers, floor: "4F", mapNumber: 3,
            duration: 50, minAge: 48, maxAge: 780, capacity: 25, joyCurrency: 0,
            icon: "✂️", isPopular: false, interestType: ["A"]
        ),
        ExperienceRoom(
            id: "makers-04", name: "K.ground 미니체험B", hall: .makers, floor: "4F", mapNumber: 4,
            duration: 50, minAge: 48, maxAge: 780, capacity: 25, joyCurrency: 0,
            icon: "✂️", isPopular: false, interestType: ["A"]
        ),

        // MARK: - M.street (5F) — 다양한 체험 프로그램

        ExperienceRoom(
            id: "makers-05", name: "M.street 디지털공작소", hall: .makers, floor: "5F", mapNumber: 5,
            duration: 60, minAge: 84, maxAge: 780, capacity: 15, joyCurrency: 0,
            icon: "💻", isPopular: true, interestType: ["I", "R"]
        ),
        ExperienceRoom(
            id: "makers-06", name: "M.street 공예공방", hall: .makers, floor: "5F", mapNumber: 6,
            duration: 60, minAge: 84, maxAge: 780, capacity: 15, joyCurrency: 0,
            icon: "🎨", isPopular: false, interestType: ["A"]
        ),
        ExperienceRoom(
            id: "makers-07", name: "M.street 미디어랩", hall: .makers, floor: "5F", mapNumber: 7,
            duration: 60, minAge: 84, maxAge: 780, capacity: 12, joyCurrency: 0,
            icon: "🎬", isPopular: false, interestType: ["A", "I"]
        ),
        ExperienceRoom(
            id: "makers-08", name: "M.street 요리공방", hall: .makers, floor: "5F", mapNumber: 8,
            duration: 60, minAge: 84, maxAge: 780, capacity: 12, joyCurrency: 0,
            icon: "🍳", isPopular: true, interestType: ["R", "A"]
        ),

        // MARK: - Y.class — 교육 프로그램

        ExperienceRoom(
            id: "makers-09", name: "Y.class 코딩교실", hall: .makers, floor: "5F", mapNumber: 9,
            duration: 90, minAge: 120, maxAge: 780, capacity: 20, joyCurrency: 0,
            icon: "🖥️", isPopular: false, interestType: ["I", "C"]
        ),
        ExperienceRoom(
            id: "makers-10", name: "Y.class 메이커교육", hall: .makers, floor: "5F", mapNumber: 10,
            duration: 90, minAge: 120, maxAge: 780, capacity: 20, joyCurrency: 0,
            icon: "🛠️", isPopular: false, interestType: ["R", "I"]
        ),
    ]

    /// K.ground 입장료 정보
    enum KGroundFee {
        /// 90분 체험 가격 (원)
        static let fullSession: Int = 15000
        /// 50분 미니체험 가격 (원)
        static let miniSession: Int = 10000
    }
}
