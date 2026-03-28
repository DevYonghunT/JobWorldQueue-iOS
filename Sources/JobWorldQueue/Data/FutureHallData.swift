// FutureHallData.swift
// 미래직업관 18개 체험실 데이터

import Foundation

/// 미래직업관 데이터
enum FutureHallData {
    /// 미래직업관 전체 18개 체험실
    static let rooms: [ExperienceRoom] = [
        ExperienceRoom(
            id: "future-01", name: "미래직업관안내", hall: .future, floor: "1F", mapNumber: 1,
            duration: 15, minAge: 120, maxAge: 216, capacity: 20, joyCurrency: 0,
            icon: "ℹ️", isPopular: false, interestType: ["C"]
        ),
        ExperienceRoom(
            id: "future-02", name: "주제영상관", hall: .future, floor: "1F", mapNumber: 2,
            duration: 20, minAge: 120, maxAge: 216, capacity: 30, joyCurrency: 0,
            icon: "🎥", isPopular: false, interestType: ["A"]
        ),
        ExperienceRoom(
            id: "future-03", name: "반도체클린룸", hall: .future, floor: "2F", mapNumber: 3,
            duration: 30, minAge: 120, maxAge: 216, capacity: 10, joyCurrency: 5,
            icon: "🔬", isPopular: true, interestType: ["R", "I"]
        ),
        ExperienceRoom(
            id: "future-04", name: "반도체캠퍼스", hall: .future, floor: "2F", mapNumber: 4,
            duration: 25, minAge: 120, maxAge: 216, capacity: 12, joyCurrency: 3,
            icon: "📡", isPopular: false, interestType: ["I"]
        ),
        ExperienceRoom(
            id: "future-05", name: "디지털트윈으로기후위기?", hall: .future, floor: "2F", mapNumber: 5,
            duration: 30, minAge: 120, maxAge: 216, capacity: 10, joyCurrency: 5,
            icon: "🌍", isPopular: true, interestType: ["I", "S"]
        ),
        ExperienceRoom(
            id: "future-06", name: "유전자치료제를완성하라!", hall: .future, floor: "2F", mapNumber: 6,
            duration: 30, minAge: 120, maxAge: 216, capacity: 8, joyCurrency: 5,
            icon: "🧬", isPopular: true, interestType: ["I"]
        ),
        ExperienceRoom(
            id: "future-07", name: "로봇시스템인그레이더", hall: .future, floor: "2F", mapNumber: 7,
            duration: 30, minAge: 120, maxAge: 216, capacity: 8, joyCurrency: 5,
            icon: "🤖", isPopular: true, interestType: ["R", "I"]
        ),
        ExperienceRoom(
            id: "future-08", name: "UAM조종사", hall: .future, floor: "2F", mapNumber: 8,
            duration: 30, minAge: 120, maxAge: 216, capacity: 6, joyCurrency: 5,
            icon: "🛩️", isPopular: true, interestType: ["R"]
        ),
        ExperienceRoom(
            id: "future-09", name: "양자컴퓨터학자", hall: .future, floor: "2F", mapNumber: 9,
            duration: 25, minAge: 132, maxAge: 216, capacity: 8, joyCurrency: 5,
            icon: "💎", isPopular: false, interestType: ["I"]
        ),
        ExperienceRoom(
            id: "future-10", name: "메타버스아키텍트", hall: .future, floor: "2F", mapNumber: 10,
            duration: 30, minAge: 120, maxAge: 216, capacity: 8, joyCurrency: 5,
            icon: "🌐", isPopular: true, interestType: ["A", "I"]
        ),
        ExperienceRoom(
            id: "future-11", name: "패러데이는을만들라!", hall: .future, floor: "3F", mapNumber: 11,
            duration: 25, minAge: 120, maxAge: 216, capacity: 10, joyCurrency: 5,
            icon: "⚡", isPopular: false, interestType: ["R", "I"]
        ),
        ExperienceRoom(
            id: "future-12", name: "디지털웰다잉아이데이터!", hall: .future, floor: "3F", mapNumber: 12,
            duration: 25, minAge: 120, maxAge: 216, capacity: 10, joyCurrency: 5,
            icon: "💾", isPopular: false, interestType: ["I", "S"]
        ),
        ExperienceRoom(
            id: "future-13", name: "3D프린팅대체식품셰프", hall: .future, floor: "3F", mapNumber: 13,
            duration: 30, minAge: 120, maxAge: 216, capacity: 8, joyCurrency: 5,
            icon: "🖨️", isPopular: true, interestType: ["R", "A"]
        ),
        ExperienceRoom(
            id: "future-14", name: "기후파이팅알라인!", hall: .future, floor: "3F", mapNumber: 14,
            duration: 25, minAge: 120, maxAge: 216, capacity: 10, joyCurrency: 5,
            icon: "🌡️", isPopular: false, interestType: ["I", "S"]
        ),
        ExperienceRoom(
            id: "future-15", name: "뉴스페이스/AI경찰의사", hall: .future, floor: "3F", mapNumber: 15,
            duration: 30, minAge: 120, maxAge: 216, capacity: 8, joyCurrency: 5,
            icon: "🚀", isPopular: true, interestType: ["R", "I"]
        ),
        ExperienceRoom(
            id: "future-16", name: "지능형도시컨설턴트", hall: .future, floor: "3F", mapNumber: 16,
            duration: 30, minAge: 120, maxAge: 216, capacity: 10, joyCurrency: 5,
            icon: "🏙️", isPopular: false, interestType: ["I", "E"]
        ),
        ExperienceRoom(
            id: "future-17", name: "AI미래직업역량측정", hall: .future, floor: "3F", mapNumber: 17,
            duration: 20, minAge: 120, maxAge: 216, capacity: 15, joyCurrency: 0,
            icon: "🤖", isPopular: false, interestType: ["I", "C"]
        ),
        ExperienceRoom(
            id: "future-18", name: "AI포토존", hall: .future, floor: "3F", mapNumber: 18,
            duration: 15, minAge: 120, maxAge: 216, capacity: 20, joyCurrency: 0,
            icon: "📸", isPopular: false, interestType: ["A"]
        ),
    ]
}
