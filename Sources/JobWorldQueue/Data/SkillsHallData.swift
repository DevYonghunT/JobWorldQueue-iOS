// SkillsHallData.swift
// 숙련기술체험관 19개 체험실 데이터

import Foundation

/// 숙련기술체험관 데이터 (3개 층)
enum SkillsHallData {
    /// 숙련기술체험관 전체 19개 체험실
    static let rooms: [ExperienceRoom] = [
        // MARK: - 1F
        ExperienceRoom(
            id: "skills-01", name: "안내데스크", hall: .skills, floor: "1F", mapNumber: 1,
            duration: 10, minAge: 120, maxAge: 216, capacity: 30, joyCurrency: 0,
            icon: "🪧", isPopular: false, interestType: ["C"]
        ),
        ExperienceRoom(
            id: "skills-02", name: "숙련명품전시관", hall: .skills, floor: "1F", mapNumber: 2,
            duration: 20, minAge: 120, maxAge: 216, capacity: 20, joyCurrency: 0,
            icon: "🏆", isPopular: false, interestType: ["R", "A"]
        ),
        ExperienceRoom(
            id: "skills-03", name: "홍보/역사실", hall: .skills, floor: "1F", mapNumber: 3,
            duration: 15, minAge: 120, maxAge: 216, capacity: 25, joyCurrency: 0,
            icon: "📜", isPopular: false, interestType: ["I"]
        ),
        ExperienceRoom(
            id: "skills-04", name: "전산센터", hall: .skills, floor: "1F", mapNumber: 4,
            duration: 25, minAge: 120, maxAge: 216, capacity: 10, joyCurrency: 5,
            icon: "💻", isPopular: false, interestType: ["I", "C"]
        ),
        ExperienceRoom(
            id: "skills-05", name: "소회의실", hall: .skills, floor: "1F", mapNumber: 5,
            duration: 20, minAge: 120, maxAge: 216, capacity: 15, joyCurrency: 0,
            icon: "🪑", isPopular: false, interestType: ["C"]
        ),
        ExperienceRoom(
            id: "skills-06", name: "대회의실", hall: .skills, floor: "1F", mapNumber: 6,
            duration: 20, minAge: 120, maxAge: 216, capacity: 30, joyCurrency: 0,
            icon: "🏛️", isPopular: false, interestType: ["C"]
        ),
        ExperienceRoom(
            id: "skills-07", name: "소강의실/세미나실", hall: .skills, floor: "1F", mapNumber: 7,
            duration: 25, minAge: 120, maxAge: 216, capacity: 20, joyCurrency: 0,
            icon: "📋", isPopular: false, interestType: ["C"]
        ),

        // MARK: - 2F
        ExperienceRoom(
            id: "skills-08", name: "환상의섬", hall: .skills, floor: "2F", mapNumber: 8,
            duration: 30, minAge: 120, maxAge: 216, capacity: 10, joyCurrency: 5,
            icon: "🏝️", isPopular: true, interestType: ["A", "R"]
        ),
        ExperienceRoom(
            id: "skills-09", name: "디지털생동공조", hall: .skills, floor: "2F", mapNumber: 9,
            duration: 30, minAge: 120, maxAge: 216, capacity: 8, joyCurrency: 5,
            icon: "🌡️", isPopular: false, interestType: ["R", "I"]
        ),
        ExperienceRoom(
            id: "skills-10", name: "항공정비엔지니어", hall: .skills, floor: "2F", mapNumber: 10,
            duration: 35, minAge: 120, maxAge: 216, capacity: 8, joyCurrency: 5,
            icon: "✈️", isPopular: true, interestType: ["R"]
        ),
        ExperienceRoom(
            id: "skills-11", name: "로봇을만들자", hall: .skills, floor: "2F", mapNumber: 11,
            duration: 35, minAge: 120, maxAge: 216, capacity: 8, joyCurrency: 5,
            icon: "🤖", isPopular: true, interestType: ["R", "I"]
        ),
        ExperienceRoom(
            id: "skills-12", name: "과학포렌식챌린지", hall: .skills, floor: "2F", mapNumber: 12,
            duration: 30, minAge: 120, maxAge: 216, capacity: 10, joyCurrency: 5,
            icon: "🔍", isPopular: true, interestType: ["I", "R"]
        ),
        ExperienceRoom(
            id: "skills-13", name: "스마트팩토리", hall: .skills, floor: "2F", mapNumber: 13,
            duration: 30, minAge: 120, maxAge: 216, capacity: 10, joyCurrency: 5,
            icon: "🏭", isPopular: true, interestType: ["R", "I"]
        ),

        // MARK: - 3F
        ExperienceRoom(
            id: "skills-14", name: "취업/창업교육실", hall: .skills, floor: "3F", mapNumber: 14,
            duration: 25, minAge: 132, maxAge: 216, capacity: 15, joyCurrency: 3,
            icon: "💼", isPopular: false, interestType: ["E", "C"]
        ),
        ExperienceRoom(
            id: "skills-15", name: "오니(네일)매니큐어제", hall: .skills, floor: "3F", mapNumber: 15,
            duration: 30, minAge: 120, maxAge: 216, capacity: 8, joyCurrency: 5,
            icon: "💅", isPopular: true, interestType: ["A"]
        ),
        ExperienceRoom(
            id: "skills-16", name: "슈마인반", hall: .skills, floor: "3F", mapNumber: 16,
            duration: 30, minAge: 120, maxAge: 216, capacity: 8, joyCurrency: -3,
            icon: "👟", isPopular: false, interestType: ["A", "R"]
        ),
        ExperienceRoom(
            id: "skills-17", name: "청년소스", hall: .skills, floor: "3F", mapNumber: 17,
            duration: 25, minAge: 132, maxAge: 216, capacity: 10, joyCurrency: 5,
            icon: "🍳", isPopular: false, interestType: ["R", "A"]
        ),
        ExperienceRoom(
            id: "skills-18", name: "친구와팩토리", hall: .skills, floor: "3F", mapNumber: 18,
            duration: 30, minAge: 120, maxAge: 216, capacity: 10, joyCurrency: 5,
            icon: "🤝", isPopular: false, interestType: ["R", "S"]
        ),
        ExperienceRoom(
            id: "skills-19", name: "연금술학교", hall: .skills, floor: "3F", mapNumber: 19,
            duration: 30, minAge: 120, maxAge: 216, capacity: 10, joyCurrency: 5,
            icon: "⚗️", isPopular: true, interestType: ["I", "R"]
        ),
    ]
}
