// YouthHallData.swift
// 청소년체험관 43개 체험실 데이터

import Foundation

/// 청소년체험관 데이터 (초등 고학년~중학생)
enum YouthHallData {
    /// 청소년체험관 전체 43개 체험실
    static let rooms: [ExperienceRoom] = [
        ExperienceRoom(
            id: "youth-01", name: "군훈련캠프", hall: .youth, floor: "3F", mapNumber: 1,
            duration: 35, minAge: 108, maxAge: 192, capacity: 12, joyCurrency: 5,
            icon: "🎖️", isPopular: true, interestType: ["R"]
        ),
        ExperienceRoom(
            id: "youth-02", name: "과학수사센터", hall: .youth, floor: "3F", mapNumber: 2,
            duration: 35, minAge: 108, maxAge: 192, capacity: 10, joyCurrency: 5,
            icon: "🔬", isPopular: true, interestType: ["I", "R"]
        ),
        ExperienceRoom(
            id: "youth-03", name: "경찰서비스", hall: .youth, floor: "3F", mapNumber: 3,
            duration: 30, minAge: 108, maxAge: 192, capacity: 10, joyCurrency: 5,
            icon: "🚔", isPopular: true, interestType: ["R", "S"]
        ),
        ExperienceRoom(
            id: "youth-04", name: "미래모빌리티:자율주행", hall: .youth, floor: "3F", mapNumber: 4,
            duration: 30, minAge: 120, maxAge: 192, capacity: 8, joyCurrency: 5,
            icon: "🚗", isPopular: true, interestType: ["R", "I"]
        ),
        ExperienceRoom(
            id: "youth-05", name: "환경실", hall: .youth, floor: "3F", mapNumber: 5,
            duration: 25, minAge: 108, maxAge: 192, capacity: 10, joyCurrency: 5,
            icon: "🌿", isPopular: false, interestType: ["I", "S"]
        ),
        ExperienceRoom(
            id: "youth-06", name: "소방서", hall: .youth, floor: "3F", mapNumber: 6,
            duration: 30, minAge: 108, maxAge: 192, capacity: 10, joyCurrency: 5,
            icon: "🚒", isPopular: true, interestType: ["R", "S"]
        ),
        ExperienceRoom(
            id: "youth-07", name: "항공사(승무원)", hall: .youth, floor: "3F", mapNumber: 7,
            duration: 30, minAge: 108, maxAge: 192, capacity: 8, joyCurrency: 5,
            icon: "✈️", isPopular: true, interestType: ["S", "E"]
        ),
        ExperienceRoom(
            id: "youth-08", name: "패션(디자인)", hall: .youth, floor: "3F", mapNumber: 8,
            duration: 30, minAge: 108, maxAge: 192, capacity: 8, joyCurrency: 5,
            icon: "👗", isPopular: false, interestType: ["A"]
        ),
        ExperienceRoom(
            id: "youth-09", name: "그린크래프트", hall: .youth, floor: "3F", mapNumber: 9,
            duration: 25, minAge: 108, maxAge: 192, capacity: 10, joyCurrency: 3,
            icon: "🌱", isPopular: false, interestType: ["R", "A"]
        ),
        ExperienceRoom(
            id: "youth-10", name: "리그오브오션", hall: .youth, floor: "3F", mapNumber: 10,
            duration: 25, minAge: 108, maxAge: 192, capacity: 12, joyCurrency: -3,
            icon: "🌊", isPopular: true, interestType: ["R"]
        ),
        ExperienceRoom(
            id: "youth-11", name: "초등학교(교사)", hall: .youth, floor: "3F", mapNumber: 11,
            duration: 30, minAge: 108, maxAge: 192, capacity: 10, joyCurrency: 5,
            icon: "🏫", isPopular: false, interestType: ["S", "E"]
        ),
        ExperienceRoom(
            id: "youth-12", name: "방송", hall: .youth, floor: "3F", mapNumber: 12,
            duration: 35, minAge: 108, maxAge: 192, capacity: 8, joyCurrency: 5,
            icon: "📡", isPopular: true, interestType: ["A", "E"]
        ),
        ExperienceRoom(
            id: "youth-13", name: "재판(법원)", hall: .youth, floor: "MF", mapNumber: 13,
            duration: 35, minAge: 120, maxAge: 192, capacity: 12, joyCurrency: 5,
            icon: "⚖️", isPopular: true, interestType: ["E", "S"]
        ),
        ExperienceRoom(
            id: "youth-14", name: "증권회사", hall: .youth, floor: "MF", mapNumber: 14,
            duration: 30, minAge: 120, maxAge: 192, capacity: 10, joyCurrency: 5,
            icon: "📈", isPopular: false, interestType: ["E", "C"]
        ),
        ExperienceRoom(
            id: "youth-15", name: "팬슈터드", hall: .youth, floor: "MF", mapNumber: 15,
            duration: 25, minAge: 108, maxAge: 192, capacity: 10, joyCurrency: -3,
            icon: "🎯", isPopular: false, interestType: ["R"]
        ),
        ExperienceRoom(
            id: "youth-16", name: "그린에너지스테이션", hall: .youth, floor: "MF", mapNumber: 16,
            duration: 25, minAge: 108, maxAge: 192, capacity: 10, joyCurrency: 5,
            icon: "🔋", isPopular: false, interestType: ["R", "I"]
        ),
        ExperienceRoom(
            id: "youth-17", name: "ABO놀이터", hall: .youth, floor: "MF", mapNumber: 17,
            duration: 20, minAge: 108, maxAge: 192, capacity: 12, joyCurrency: -3,
            icon: "🩸", isPopular: false, interestType: ["I", "S"]
        ),
        ExperienceRoom(
            id: "youth-18", name: "생활과학연구소", hall: .youth, floor: "MF", mapNumber: 18,
            duration: 30, minAge: 108, maxAge: 192, capacity: 10, joyCurrency: 5,
            icon: "🧪", isPopular: false, interestType: ["I"]
        ),
        ExperienceRoom(
            id: "youth-19", name: "로봇공학연구소", hall: .youth, floor: "MF", mapNumber: 19,
            duration: 35, minAge: 120, maxAge: 192, capacity: 8, joyCurrency: 5,
            icon: "🤖", isPopular: true, interestType: ["R", "I"]
        ),
        ExperienceRoom(
            id: "youth-20", name: "자동차디자인스튜디오", hall: .youth, floor: "MF", mapNumber: 20,
            duration: 30, minAge: 108, maxAge: 192, capacity: 8, joyCurrency: 5,
            icon: "🚙", isPopular: false, interestType: ["A", "R"]
        ),
        ExperienceRoom(
            id: "youth-21", name: "메타버스앱", hall: .youth, floor: "MF", mapNumber: 21,
            duration: 25, minAge: 120, maxAge: 192, capacity: 10, joyCurrency: 5,
            icon: "🌐", isPopular: true, interestType: ["I", "A"]
        ),
        ExperienceRoom(
            id: "youth-22", name: "종합병원(수술실)", hall: .youth, floor: "MF", mapNumber: 22,
            duration: 35, minAge: 108, maxAge: 192, capacity: 8, joyCurrency: 5,
            icon: "🏥", isPopular: true, interestType: ["I", "R"]
        ),
        ExperienceRoom(
            id: "youth-23", name: "스마트재활센터", hall: .youth, floor: "MF", mapNumber: 23,
            duration: 25, minAge: 108, maxAge: 192, capacity: 8, joyCurrency: 5,
            icon: "🦾", isPopular: false, interestType: ["I", "S"]
        ),
        ExperienceRoom(
            id: "youth-24", name: "스마트해상교통관제센터", hall: .youth, floor: "MF", mapNumber: 24,
            duration: 25, minAge: 120, maxAge: 192, capacity: 8, joyCurrency: 5,
            icon: "🚢", isPopular: false, interestType: ["R", "C"]
        ),
        ExperienceRoom(
            id: "youth-25", name: "119안전센터", hall: .youth, floor: "4F", mapNumber: 25,
            duration: 30, minAge: 108, maxAge: 192, capacity: 10, joyCurrency: 5,
            icon: "🚑", isPopular: true, interestType: ["R", "S"]
        ),
        ExperienceRoom(
            id: "youth-26", name: "항공사", hall: .youth, floor: "4F", mapNumber: 26,
            duration: 30, minAge: 108, maxAge: 192, capacity: 8, joyCurrency: 5,
            icon: "🛫", isPopular: true, interestType: ["R", "E"]
        ),
        ExperienceRoom(
            id: "youth-27", name: "항공사(조종사)", hall: .youth, floor: "4F", mapNumber: 27,
            duration: 35, minAge: 120, maxAge: 192, capacity: 6, joyCurrency: 5,
            icon: "👨‍✈️", isPopular: true, interestType: ["R", "I"]
        ),
        ExperienceRoom(
            id: "youth-28", name: "레스토랑", hall: .youth, floor: "4F", mapNumber: 28,
            duration: 30, minAge: 108, maxAge: 192, capacity: 8, joyCurrency: -3,
            icon: "🍽️", isPopular: false, interestType: ["A", "R"]
        ),
        ExperienceRoom(
            id: "youth-29", name: "메이크업/화장품연구소", hall: .youth, floor: "4F", mapNumber: 29,
            duration: 30, minAge: 108, maxAge: 192, capacity: 8, joyCurrency: 5,
            icon: "💄", isPopular: true, interestType: ["A", "I"]
        ),
        ExperienceRoom(
            id: "youth-30", name: "유전자치료제완성하라", hall: .youth, floor: "4F", mapNumber: 30,
            duration: 30, minAge: 120, maxAge: 192, capacity: 8, joyCurrency: 5,
            icon: "🧬", isPopular: false, interestType: ["I"]
        ),
        ExperienceRoom(
            id: "youth-31", name: "녹음스튜디오", hall: .youth, floor: "4F", mapNumber: 31,
            duration: 30, minAge: 108, maxAge: 192, capacity: 6, joyCurrency: 5,
            icon: "🎙️", isPopular: true, interestType: ["A"]
        ),
        ExperienceRoom(
            id: "youth-32", name: "패션쇼장", hall: .youth, floor: "4F", mapNumber: 32,
            duration: 30, minAge: 108, maxAge: 192, capacity: 10, joyCurrency: -3,
            icon: "👠", isPopular: false, interestType: ["A", "E"]
        ),
        ExperienceRoom(
            id: "youth-33", name: "그린크래프트", hall: .youth, floor: "4F", mapNumber: 33,
            duration: 25, minAge: 108, maxAge: 192, capacity: 10, joyCurrency: 3,
            icon: "🌿", isPopular: false, interestType: ["R", "A"]
        ),
        ExperienceRoom(
            id: "youth-34", name: "카라미아빠르시카", hall: .youth, floor: "4F", mapNumber: 34,
            duration: 25, minAge: 108, maxAge: 192, capacity: 8, joyCurrency: -3,
            icon: "🍫", isPopular: false, interestType: ["A", "R"]
        ),
        ExperienceRoom(
            id: "youth-35", name: "청년기관", hall: .youth, floor: "4F", mapNumber: 35,
            duration: 25, minAge: 120, maxAge: 192, capacity: 10, joyCurrency: 5,
            icon: "🏢", isPopular: false, interestType: ["S", "E"]
        ),
        ExperienceRoom(
            id: "youth-36", name: "수의사", hall: .youth, floor: "4F", mapNumber: 36,
            duration: 30, minAge: 108, maxAge: 192, capacity: 8, joyCurrency: 5,
            icon: "🐕", isPopular: true, interestType: ["I", "R"]
        ),
        ExperienceRoom(
            id: "youth-37", name: "직업세계발전소", hall: .youth, floor: "4F", mapNumber: 37,
            duration: 20, minAge: 108, maxAge: 192, capacity: 12, joyCurrency: 3,
            icon: "⚙️", isPopular: false, interestType: ["I", "E"]
        ),
        ExperienceRoom(
            id: "youth-38", name: "스마트팜밴드", hall: .youth, floor: "4F", mapNumber: 38,
            duration: 25, minAge: 108, maxAge: 192, capacity: 10, joyCurrency: 5,
            icon: "🌾", isPopular: false, interestType: ["R", "I"]
        ),
        ExperienceRoom(
            id: "youth-39", name: "바이오산학연구소", hall: .youth, floor: "5F", mapNumber: 39,
            duration: 30, minAge: 120, maxAge: 192, capacity: 8, joyCurrency: 5,
            icon: "🧫", isPopular: false, interestType: ["I"]
        ),
        ExperienceRoom(
            id: "youth-40", name: "마약감시본부", hall: .youth, floor: "5F", mapNumber: 40,
            duration: 30, minAge: 120, maxAge: 192, capacity: 10, joyCurrency: 5,
            icon: "🛡️", isPopular: false, interestType: ["R", "I"]
        ),
        ExperienceRoom(
            id: "youth-41", name: "바이오산업연구소", hall: .youth, floor: "5F", mapNumber: 41,
            duration: 30, minAge: 120, maxAge: 192, capacity: 8, joyCurrency: 5,
            icon: "🔭", isPopular: false, interestType: ["I"]
        ),
        ExperienceRoom(
            id: "youth-42", name: "첨단교실학부", hall: .youth, floor: "5F", mapNumber: 42,
            duration: 30, minAge: 120, maxAge: 192, capacity: 10, joyCurrency: 5,
            icon: "💻", isPopular: false, interestType: ["I", "E"]
        ),
        ExperienceRoom(
            id: "youth-43", name: "인지과학사", hall: .youth, floor: "5F", mapNumber: 43,
            duration: 30, minAge: 120, maxAge: 192, capacity: 8, joyCurrency: 5,
            icon: "🧠", isPopular: false, interestType: ["I"]
        ),
    ]
}
