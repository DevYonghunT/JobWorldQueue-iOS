// ChildrenHallData.swift
// 어린이체험관 42개 체험실 데이터

import Foundation

/// 어린이체험관 데이터 (만 3세~초등 저학년)
enum ChildrenHallData {
    /// 어린이체험관 전체 42개 체험실
    static let rooms: [ExperienceRoom] = [
        ExperienceRoom(
            id: "children-01", name: "건설탐험대", hall: .children, floor: "3F", mapNumber: 1,
            duration: 30, minAge: 48, maxAge: 120, capacity: 10, joyCurrency: 5,
            icon: "🏗️", isPopular: true, interestType: ["R"]
        ),
        ExperienceRoom(
            id: "children-02", name: "애니메이션스튜디오", hall: .children, floor: "3F", mapNumber: 2,
            duration: 30, minAge: 48, maxAge: 120, capacity: 10, joyCurrency: 5,
            icon: "🎬", isPopular: true, interestType: ["A"]
        ),
        ExperienceRoom(
            id: "children-03", name: "피자가게", hall: .children, floor: "3F", mapNumber: 3,
            duration: 25, minAge: 36, maxAge: 120, capacity: 8, joyCurrency: -3,
            icon: "🍕", isPopular: true, interestType: ["R", "A"]
        ),
        ExperienceRoom(
            id: "children-04", name: "병원신생아실", hall: .children, floor: "3F", mapNumber: 4,
            duration: 25, minAge: 36, maxAge: 108, capacity: 8, joyCurrency: 5,
            icon: "👶", isPopular: false, interestType: ["S", "I"]
        ),
        ExperienceRoom(
            id: "children-05", name: "외과수술실", hall: .children, floor: "3F", mapNumber: 5,
            duration: 30, minAge: 48, maxAge: 120, capacity: 8, joyCurrency: 5,
            icon: "🏥", isPopular: true, interestType: ["I", "R"]
        ),
        ExperienceRoom(
            id: "children-06", name: "신문사", hall: .children, floor: "3F", mapNumber: 6,
            duration: 25, minAge: 60, maxAge: 120, capacity: 10, joyCurrency: 5,
            icon: "📰", isPopular: false, interestType: ["A", "I"]
        ),
        ExperienceRoom(
            id: "children-07", name: "디지털갤러리", hall: .children, floor: "3F", mapNumber: 7,
            duration: 20, minAge: 36, maxAge: 120, capacity: 12, joyCurrency: -3,
            icon: "🖼️", isPopular: false, interestType: ["A"]
        ),
        ExperienceRoom(
            id: "children-08", name: "달콤카페", hall: .children, floor: "3F", mapNumber: 8,
            duration: 25, minAge: 36, maxAge: 108, capacity: 8, joyCurrency: -3,
            icon: "☕", isPopular: true, interestType: ["R", "E"]
        ),
        ExperienceRoom(
            id: "children-09", name: "동물병원", hall: .children, floor: "3F", mapNumber: 9,
            duration: 25, minAge: 36, maxAge: 120, capacity: 8, joyCurrency: 5,
            icon: "🐾", isPopular: true, interestType: ["I", "S"]
        ),
        ExperienceRoom(
            id: "children-10", name: "레이싱경기장", hall: .children, floor: "3F", mapNumber: 10,
            duration: 20, minAge: 48, maxAge: 120, capacity: 6, joyCurrency: -3,
            icon: "🏎️", isPopular: true, interestType: ["R"]
        ),
        ExperienceRoom(
            id: "children-11", name: "야구경기장", hall: .children, floor: "3F", mapNumber: 11,
            duration: 20, minAge: 48, maxAge: 120, capacity: 10, joyCurrency: -3,
            icon: "⚾", isPopular: false, interestType: ["R"]
        ),
        ExperienceRoom(
            id: "children-12", name: "슈즈아틀리에", hall: .children, floor: "3F", mapNumber: 12,
            duration: 30, minAge: 48, maxAge: 120, capacity: 8, joyCurrency: -5,
            icon: "👟", isPopular: false, interestType: ["A", "R"]
        ),
        ExperienceRoom(
            id: "children-13", name: "AR신발패턴실", hall: .children, floor: "3F", mapNumber: 13,
            duration: 20, minAge: 48, maxAge: 120, capacity: 8, joyCurrency: 3,
            icon: "👠", isPopular: false, interestType: ["A", "I"]
        ),
        ExperienceRoom(
            id: "children-14", name: "드론연구소", hall: .children, floor: "3F", mapNumber: 14,
            duration: 25, minAge: 60, maxAge: 120, capacity: 8, joyCurrency: 5,
            icon: "🛸", isPopular: true, interestType: ["R", "I"]
        ),
        ExperienceRoom(
            id: "children-15", name: "피자가게", hall: .children, floor: "MF", mapNumber: 15,
            duration: 25, minAge: 36, maxAge: 120, capacity: 8, joyCurrency: -3,
            icon: "🍕", isPopular: false, interestType: ["R", "A"]
        ),
        ExperienceRoom(
            id: "children-16", name: "K-POP스테이지", hall: .children, floor: "MF", mapNumber: 16,
            duration: 30, minAge: 48, maxAge: 120, capacity: 12, joyCurrency: -5,
            icon: "🎤", isPopular: true, interestType: ["A", "E"]
        ),
        ExperienceRoom(
            id: "children-17", name: "Hi스토리TV", hall: .children, floor: "MF", mapNumber: 17,
            duration: 25, minAge: 48, maxAge: 120, capacity: 10, joyCurrency: 5,
            icon: "📺", isPopular: false, interestType: ["A", "I"]
        ),
        ExperienceRoom(
            id: "children-18", name: "미용실", hall: .children, floor: "MF", mapNumber: 18,
            duration: 25, minAge: 48, maxAge: 120, capacity: 6, joyCurrency: 5,
            icon: "💇", isPopular: true, interestType: ["A", "S"]
        ),
        ExperienceRoom(
            id: "children-19", name: "과자가게", hall: .children, floor: "MF", mapNumber: 19,
            duration: 25, minAge: 36, maxAge: 108, capacity: 8, joyCurrency: -3,
            icon: "🍪", isPopular: true, interestType: ["R", "A"]
        ),
        ExperienceRoom(
            id: "children-20", name: "키즈미디어스튜디오", hall: .children, floor: "MF", mapNumber: 20,
            duration: 30, minAge: 48, maxAge: 120, capacity: 8, joyCurrency: 5,
            icon: "📱", isPopular: false, interestType: ["A", "I"]
        ),
        ExperienceRoom(
            id: "children-21", name: "방송국", hall: .children, floor: "MF", mapNumber: 21,
            duration: 30, minAge: 48, maxAge: 120, capacity: 10, joyCurrency: 5,
            icon: "📡", isPopular: true, interestType: ["A", "E"]
        ),
        ExperienceRoom(
            id: "children-22", name: "사회복지관", hall: .children, floor: "MF", mapNumber: 22,
            duration: 25, minAge: 48, maxAge: 120, capacity: 10, joyCurrency: 5,
            icon: "🤝", isPopular: false, interestType: ["S"]
        ),
        ExperienceRoom(
            id: "children-23", name: "재활의학연구소", hall: .children, floor: "MF", mapNumber: 23,
            duration: 25, minAge: 48, maxAge: 120, capacity: 8, joyCurrency: 5,
            icon: "🦽", isPopular: false, interestType: ["I", "S"]
        ),
        ExperienceRoom(
            id: "children-24", name: "스마트해상교통관제센터", hall: .children, floor: "MF", mapNumber: 24,
            duration: 25, minAge: 60, maxAge: 120, capacity: 8, joyCurrency: 5,
            icon: "🚢", isPopular: false, interestType: ["R", "C"]
        ),
        ExperienceRoom(
            id: "children-25", name: "우주센터", hall: .children, floor: "MF", mapNumber: 25,
            duration: 30, minAge: 48, maxAge: 120, capacity: 10, joyCurrency: 5,
            icon: "🚀", isPopular: true, interestType: ["I", "R"]
        ),
        ExperienceRoom(
            id: "children-26", name: "마법사학교", hall: .children, floor: "MF", mapNumber: 26,
            duration: 20, minAge: 36, maxAge: 96, capacity: 12, joyCurrency: -3,
            icon: "🧙", isPopular: true, interestType: ["A"]
        ),
        ExperienceRoom(
            id: "children-27", name: "택배회사", hall: .children, floor: "4F", mapNumber: 27,
            duration: 25, minAge: 48, maxAge: 120, capacity: 8, joyCurrency: 5,
            icon: "📦", isPopular: false, interestType: ["R", "C"]
        ),
        ExperienceRoom(
            id: "children-28", name: "꽃집", hall: .children, floor: "4F", mapNumber: 28,
            duration: 25, minAge: 36, maxAge: 108, capacity: 8, joyCurrency: -3,
            icon: "🌸", isPopular: true, interestType: ["A", "R"]
        ),
        ExperienceRoom(
            id: "children-29", name: "메타버스월드", hall: .children, floor: "4F", mapNumber: 29,
            duration: 25, minAge: 60, maxAge: 120, capacity: 10, joyCurrency: -3,
            icon: "🌐", isPopular: true, interestType: ["I", "A"]
        ),
        ExperienceRoom(
            id: "children-30", name: "클라이밍아레나", hall: .children, floor: "4F", mapNumber: 30,
            duration: 20, minAge: 48, maxAge: 120, capacity: 8, joyCurrency: -3,
            icon: "🧗", isPopular: true, interestType: ["R"]
        ),
        ExperienceRoom(
            id: "children-31", name: "경찰서", hall: .children, floor: "4F", mapNumber: 31,
            duration: 30, minAge: 48, maxAge: 120, capacity: 10, joyCurrency: 5,
            icon: "🚔", isPopular: true, interestType: ["R", "S"]
        ),
        ExperienceRoom(
            id: "children-32", name: "디자인센터", hall: .children, floor: "4F", mapNumber: 32,
            duration: 25, minAge: 48, maxAge: 120, capacity: 8, joyCurrency: 5,
            icon: "🎨", isPopular: false, interestType: ["A"]
        ),
        ExperienceRoom(
            id: "children-33", name: "라이쿠아리움", hall: .children, floor: "4F", mapNumber: 33,
            duration: 25, minAge: 36, maxAge: 120, capacity: 10, joyCurrency: 5,
            icon: "🐠", isPopular: true, interestType: ["I", "R"]
        ),
        ExperienceRoom(
            id: "children-34", name: "VR게임스테이션", hall: .children, floor: "4F", mapNumber: 34,
            duration: 20, minAge: 60, maxAge: 120, capacity: 6, joyCurrency: -3,
            icon: "🎮", isPopular: true, interestType: ["R", "I"]
        ),
        ExperienceRoom(
            id: "children-35", name: "전기안전센터", hall: .children, floor: "4F", mapNumber: 35,
            duration: 25, minAge: 48, maxAge: 120, capacity: 10, joyCurrency: 5,
            icon: "⚡", isPopular: false, interestType: ["R", "S"]
        ),
        ExperienceRoom(
            id: "children-36", name: "소방서", hall: .children, floor: "4F", mapNumber: 36,
            duration: 30, minAge: 48, maxAge: 120, capacity: 10, joyCurrency: 5,
            icon: "🚒", isPopular: true, interestType: ["R", "S"]
        ),
        ExperienceRoom(
            id: "children-37", name: "자동차정비소", hall: .children, floor: "4F", mapNumber: 37,
            duration: 25, minAge: 48, maxAge: 120, capacity: 8, joyCurrency: 5,
            icon: "🔧", isPopular: false, interestType: ["R"]
        ),
        ExperienceRoom(
            id: "children-38", name: "스마트건설사이트", hall: .children, floor: "4F", mapNumber: 38,
            duration: 25, minAge: 60, maxAge: 120, capacity: 8, joyCurrency: 5,
            icon: "🏗️", isPopular: false, interestType: ["R", "I"]
        ),
        ExperienceRoom(
            id: "children-39", name: "해양경찰구조대", hall: .children, floor: "4F", mapNumber: 39,
            duration: 25, minAge: 48, maxAge: 120, capacity: 8, joyCurrency: 5,
            icon: "⛵", isPopular: false, interestType: ["R", "S"]
        ),
        ExperienceRoom(
            id: "children-40", name: "업사이클링팩토리", hall: .children, floor: "4F", mapNumber: 40,
            duration: 25, minAge: 48, maxAge: 120, capacity: 8, joyCurrency: 5,
            icon: "♻️", isPopular: false, interestType: ["R", "A"]
        ),
        ExperienceRoom(
            id: "children-41", name: "빵사이클팩토리", hall: .children, floor: "4F", mapNumber: 41,
            duration: 25, minAge: 36, maxAge: 108, capacity: 8, joyCurrency: -3,
            icon: "🍞", isPopular: false, interestType: ["R", "A"]
        ),
        ExperienceRoom(
            id: "children-42", name: "공룡캠프", hall: .children, floor: "4F", mapNumber: 42,
            duration: 30, minAge: 36, maxAge: 96, capacity: 12, joyCurrency: -5,
            icon: "🦕", isPopular: true, interestType: ["I", "R"]
        ),
    ]
}
