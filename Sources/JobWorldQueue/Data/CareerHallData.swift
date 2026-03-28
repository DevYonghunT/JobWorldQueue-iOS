// CareerHallData.swift
// 진로설계관 데이터 — 초4~고3 대상, 3,000원

import Foundation

/// 진로설계관 데이터 (초4~고3, 입장료 3,000원)
enum CareerHallData {

    /// 입장료 (원)
    static let admissionFee: Int = 3000

    /// 대상 연령 설명
    static let targetAgeDescription = "초등학교 4학년 ~ 고등학교 3학년"

    /// 진로설계관 체험실/프로그램
    static let rooms: [ExperienceRoom] = [
        // MARK: - 홍보역사실 (관람)
        ExperienceRoom(
            id: "career-01", name: "홍보역사실", hall: .career, floor: "1F", mapNumber: 1,
            duration: 15, minAge: 120, maxAge: 228, capacity: 50, joyCurrency: 0,
            icon: "📜", isPopular: false, interestType: ["C"]
        ),

        // MARK: - 체험실 (1부 09:00~11:40, 2부 12:40~14:30)
        ExperienceRoom(
            id: "career-02", name: "진로체험실A", hall: .career, floor: "2F", mapNumber: 2,
            duration: 80, minAge: 120, maxAge: 228, capacity: 30, joyCurrency: 0,
            icon: "🧭", isPopular: true, interestType: ["I", "S"]
        ),
        ExperienceRoom(
            id: "career-03", name: "진로체험실B", hall: .career, floor: "2F", mapNumber: 3,
            duration: 80, minAge: 120, maxAge: 228, capacity: 30, joyCurrency: 0,
            icon: "🧭", isPopular: true, interestType: ["E", "C"]
        ),
        ExperienceRoom(
            id: "career-04", name: "진로체험실C", hall: .career, floor: "2F", mapNumber: 4,
            duration: 80, minAge: 120, maxAge: 228, capacity: 30, joyCurrency: 0,
            icon: "🧭", isPopular: false, interestType: ["A", "R"]
        ),

        // MARK: - 직업심리검사실
        ExperienceRoom(
            id: "career-05", name: "직업심리검사실", hall: .career, floor: "3F", mapNumber: 5,
            duration: 40, minAge: 120, maxAge: 228, capacity: 20, joyCurrency: 0,
            icon: "📝", isPopular: true, interestType: ["I", "C"]
        ),

        // MARK: - 진로상담실
        ExperienceRoom(
            id: "career-06", name: "진로상담실", hall: .career, floor: "3F", mapNumber: 6,
            duration: 30, minAge: 120, maxAge: 228, capacity: 10, joyCurrency: 0,
            icon: "💬", isPopular: false, interestType: ["S", "E"]
        ),

        // MARK: - 집단상담실
        ExperienceRoom(
            id: "career-07", name: "집단상담실", hall: .career, floor: "3F", mapNumber: 7,
            duration: 50, minAge: 120, maxAge: 228, capacity: 25, joyCurrency: 0,
            icon: "👥", isPopular: false, interestType: ["S"]
        ),

        // MARK: - 진로설계 워크숍
        ExperienceRoom(
            id: "career-08", name: "진로설계 워크숍", hall: .career, floor: "2F", mapNumber: 8,
            duration: 60, minAge: 120, maxAge: 228, capacity: 30, joyCurrency: 0,
            icon: "🗺️", isPopular: false, interestType: ["E", "I"]
        ),
    ]

    /// 체험실 운영 시간 (1부/2부)
    static let experienceRoomSessions: [SessionTime] = [
        SessionTime(sessionNumber: 1, startTime: "09:00", endTime: "11:40"),
        SessionTime(sessionNumber: 2, startTime: "12:40", endTime: "14:30"),
    ]
}
