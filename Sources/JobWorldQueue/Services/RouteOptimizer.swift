// RouteOptimizer.swift
// 실시간 루트 재조정 — 체험 성공/실패 시 루트 재계산

import SwiftUI

/// 실시간 루트 재조정 서비스
extension RouteEngine {

    // MARK: - 체험 완료 처리

    /// 현재 체험 성공 완료 처리
    /// - 완료 마킹 후 다음 아이템으로 이동
    func onExperienceSuccess() {
        guard currentIndex < activeRoute.count else { return }

        withAnimation(AppTheme.springAnimation) {
            // 현재 아이템 완료 처리
            activeRoute[currentIndex].status = .completed
            completedCount += 1
            totalJoy += activeRoute[currentIndex].joyCurrency

            // 다음 아이템으로 이동
            let nextIndex = currentIndex + 1
            if nextIndex < activeRoute.count {
                currentIndex = nextIndex
                activeRoute[currentIndex].status = .active
            }
        }
    }

    /// 특정 체험실 성공 완료 처리
    /// - Parameter roomId: 완료한 체험실 ID
    func onExperienceSuccess(roomId: String) {
        guard let index = activeRoute.firstIndex(where: { $0.roomId == roomId }) else { return }

        withAnimation(AppTheme.springAnimation) {
            activeRoute[index].status = .completed
            completedCount += 1
            totalJoy += activeRoute[index].joyCurrency

            // 완료한 아이템 다음으로 currentIndex 이동
            if index == currentIndex {
                let nextIndex = currentIndex + 1
                if nextIndex < activeRoute.count {
                    currentIndex = nextIndex
                    activeRoute[currentIndex].status = .active
                }
            }
        }
    }

    // MARK: - 체험 실패 처리

    /// 현재 체험 실패 처리 — 루트 재계산
    /// - 실패한 체험을 건너뛰고 대체 체험실을 찾아 삽입
    func onExperienceFailed() {
        guard currentIndex < activeRoute.count else { return }

        withAnimation(AppTheme.springAnimation) {
            // 현재 아이템 실패 처리
            activeRoute[currentIndex].status = .failed

            // 대체 체험실 찾기
            let failedItem = activeRoute[currentIndex]
            if let replacement = findReplacementRoom(
                for: failedItem,
                currentTime: failedItem.scheduledStartTime
            ) {
                // 실패한 아이템 자리에 대체 체험실 삽입
                activeRoute[currentIndex] = replacement
                activeRoute[currentIndex].status = .active
            } else {
                // 대체 체험실이 없으면 건너뜀 처리 후 다음으로 이동
                activeRoute[currentIndex].status = .skipped
                let nextIndex = currentIndex + 1
                if nextIndex < activeRoute.count {
                    currentIndex = nextIndex
                    activeRoute[currentIndex].status = .active
                }
            }

            // 남은 루트 시간 재조정
            recalculateRemainingTimes()
        }
    }

    /// 특정 체험실 실패 처리
    /// - Parameter roomId: 실패한 체험실 ID
    func onExperienceFailed(roomId: String) {
        guard let index = activeRoute.firstIndex(where: { $0.roomId == roomId }) else { return }

        withAnimation(AppTheme.springAnimation) {
            activeRoute[index].status = .failed

            if index == currentIndex {
                onExperienceFailed()
            }
        }
    }

    // MARK: - 대체 체험실 찾기

    /// 실패한 체험 대신 할 수 있는 가장 적합한 체험실 찾기
    /// - Parameters:
    ///   - failedItem: 실패한 루트 아이템
    ///   - currentTime: 현재 시간 (HH:mm)
    /// - Returns: 대체 가능한 RouteItem (없으면 nil)
    private func findReplacementRoom(
        for failedItem: RouteItem,
        currentTime: String
    ) -> RouteItem? {
        let allRooms = ScheduleData.rooms(for: selectedHall)
        let usedRoomIds = Set(activeRoute.map(\.roomId))

        // 이미 루트에 있는 체험실 제외, 나이 적합, 같은 층 우선
        let candidates = allRooms
            .filter { !usedRoomIds.contains($0.id) }
            .filter { $0.isAgeEligible(ageInMonths: userAgeInMonths) }
            .sorted { a, b in
                // 같은 층 우선
                let aFloorMatch = a.floor == failedItem.floor
                let bFloorMatch = b.floor == failedItem.floor
                if aFloorMatch != bFloorMatch {
                    return aFloorMatch
                }
                // 선호 체험실 우선
                let aPreferred = preferredRoomIds.contains(a.id)
                let bPreferred = preferredRoomIds.contains(b.id)
                if aPreferred != bPreferred {
                    return aPreferred
                }
                // 인기 체험실 우선
                return a.isPopular && !b.isPopular
            }

        guard let replacement = candidates.first else { return nil }

        return RouteItem(
            roomId: replacement.id,
            roomName: replacement.name,
            hall: replacement.hall,
            floor: replacement.floor,
            icon: replacement.icon,
            scheduledStartTime: currentTime,
            estimatedDuration: replacement.duration,
            order: failedItem.order,
            status: .pending,
            joyCurrency: replacement.joyCurrency
        )
    }

    // MARK: - 남은 루트 시간 재계산

    /// 현재 시점부터 남은 루트의 시간을 스케줄 유형에 따라 재계산
    private func recalculateRemainingTimes() {
        guard currentIndex < activeRoute.count else { return }

        let scheduleType = ScheduleData.scheduleType(for: selectedHall)

        switch scheduleType {
        case .freeForm:
            recalculateFreeFormTimes()
        case .sessionBased, .programBased:
            recalculateSessionBasedTimes()
        case .blockBased:
            // 블록 기반은 고정 시간이므로 재계산 불필요
            break
        }
    }

    /// 자유 체험 모드 시간 재계산
    private func recalculateFreeFormTimes() {
        guard selectedBlockNumber >= 1 &&
              selectedBlockNumber <= ScheduleData.childrenBlocks.count else { return }

        let block = ScheduleData.childrenBlocks[selectedBlockNumber - 1]
        let now = Date()
        let calendar = Calendar.current
        let currentMinutes = calendar.component(.hour, from: now) * 60 +
                             calendar.component(.minute, from: now)

        var nextStartMinute = max(currentMinutes, block.startMinutes)

        for i in currentIndex..<activeRoute.count {
            guard activeRoute[i].status == .pending || activeRoute[i].status == .active else {
                continue
            }

            let duration = activeRoute[i].estimatedDuration
            let possibleSlots = block.generateTimeSlots(forDuration: duration)

            if let nextSlot = possibleSlots.first(where: { slotTime in
                let slotMin = timeStringToMinutes(slotTime)
                return slotMin >= nextStartMinute
            }) {
                activeRoute[i].scheduledStartTime = nextSlot
                nextStartMinute = timeStringToMinutes(nextSlot) + duration + block.transitionMinutes
            }
        }
    }

    /// 회차 기반 시간 재계산
    private func recalculateSessionBasedTimes() {
        let sessions = ScheduleData.sessions(for: selectedHall)
        let now = Date()
        let calendar = Calendar.current
        let currentMinutes = calendar.component(.hour, from: now) * 60 +
                             calendar.component(.minute, from: now)

        var sessionIndex = 0

        // 현재 시간 이후의 세션부터 찾기
        while sessionIndex < sessions.count &&
              sessions[sessionIndex].startMinutes < currentMinutes {
            sessionIndex += 1
        }

        for i in currentIndex..<activeRoute.count {
            guard activeRoute[i].status == .pending || activeRoute[i].status == .active else {
                continue
            }

            if sessionIndex < sessions.count {
                activeRoute[i].scheduledStartTime = sessions[sessionIndex].startTime
                sessionIndex += 1
            }
        }
    }

    /// "HH:mm" → 분 변환 (extension 내 private 유틸리티)
    private func timeStringToMinutes(_ time: String) -> Int {
        let parts = time.split(separator: ":").compactMap { Int($0) }
        guard parts.count == 2 else { return 0 }
        return parts[0] * 60 + parts[1]
    }

    // MARK: - 루트 초기화

    /// 현재 루트 완전 초기화
    func resetRoute() {
        withAnimation(AppTheme.springAnimation) {
            activeRoute = []
            currentIndex = 0
            completedCount = 0
            totalJoy = 0
            preferredRoomIds = []
        }
    }

    /// 특정 아이템 건너뛰기
    /// - Parameter index: 건너뛸 아이템 인덱스
    func skipItem(at index: Int) {
        guard index < activeRoute.count else { return }

        withAnimation(AppTheme.springAnimation) {
            activeRoute[index].status = .skipped

            if index == currentIndex {
                let nextIndex = currentIndex + 1
                if nextIndex < activeRoute.count {
                    currentIndex = nextIndex
                    activeRoute[currentIndex].status = .active
                }
            }
        }
    }

    // MARK: - 루트 상태 확인

    /// 모든 체험이 완료되었는지 확인
    var isRouteComplete: Bool {
        guard !activeRoute.isEmpty else { return false }
        return activeRoute.allSatisfy { $0.status == .completed || $0.status == .skipped || $0.status == .failed }
    }

    /// 남은 체험 수
    var remainingCount: Int {
        activeRoute.filter { $0.status == .pending || $0.status == .active }.count
    }

    /// 남은 예상 시간 (분)
    var remainingMinutes: Int {
        activeRoute
            .filter { $0.status == .pending || $0.status == .active }
            .reduce(0) { $0 + $1.estimatedDuration }
    }
}
