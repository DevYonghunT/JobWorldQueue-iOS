// TimetableView.swift
// 시간표 보기 — 체험관별 회차 시간 확인

import SwiftUI

struct TimetableView: View {
    @State private var selectedHall: HallType = .children

    /// 표시할 체험관 목록
    private let halls: [HallType] = [.children, .youth, .future, .skills]

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.paddingLarge) {
                // 체험관 선택 탭
                hallSelector

                // 회차 시간표
                sessionTimesCard

                // 체험실 목록
                roomListSection
            }
            .padding(.horizontal, AppTheme.paddingMedium)
            .padding(.top, AppTheme.paddingMedium)
            .padding(.bottom, 100)
        }
        .background(AppTheme.background.ignoresSafeArea())
        .navigationTitle("시간표")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.large)
        #endif
    }

    // MARK: - 체험관 선택

    private var hallSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(halls, id: \.self) { hall in
                    Button {
                        withAnimation(AppTheme.quickSpring) {
                            selectedHall = hall
                        }
                    } label: {
                        VStack(spacing: 6) {
                            Image(systemName: hall.icon)
                                .font(.title3)
                            Text(hall.shortName)
                                .font(AppTheme.captionFont)
                        }
                        .frame(width: 80, height: 70)
                        .background(selectedHall == hall ? hall.themeColor : AppTheme.surface)
                        .foregroundStyle(selectedHall == hall ? .white : AppTheme.textPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius, style: .continuous))
                        .shadow(color: AppTheme.cardShadow, radius: 4, x: 0, y: 2)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - 회차 시간표 카드

    private var sessionTimesCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "clock.fill")
                    .foregroundStyle(selectedHall.themeColor)
                Text("운영 시간표")
                    .font(AppTheme.subtitleFont)
                    .foregroundStyle(AppTheme.textPrimary)
            }

            let sessions = ScheduleData.sessions(for: selectedHall)
            ForEach(sessions) { session in
                HStack {
                    // 회차 번호
                    Text("\(session.sessionNumber)회차")
                        .font(AppTheme.captionFont)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .frame(width: 60)
                        .padding(.vertical, 6)
                        .background(selectedHall.themeColor)
                        .clipShape(Capsule())

                    Spacer()

                    // 시간
                    Text("\(session.startTime) ~ \(session.endTime)")
                        .font(.system(size: 16, weight: .medium, design: .monospaced))
                        .foregroundStyle(AppTheme.textPrimary)

                    Spacer()

                    // 소요 시간
                    Text("\(session.durationMinutes)분")
                        .font(AppTheme.captionFont)
                        .foregroundStyle(AppTheme.textSecondary)
                }
                .padding(.vertical, 4)

                if session.sessionNumber < sessions.count {
                    Divider()
                }
            }

            // 휴관일 안내
            HStack {
                Image(systemName: "info.circle")
                    .font(.caption)
                Text("매주 월요일 휴관")
                    .font(AppTheme.captionFont)
            }
            .foregroundStyle(AppTheme.textSecondary)
            .padding(.top, 4)
        }
        .padding(AppTheme.paddingMedium)
        .cardStyle()
    }

    // MARK: - 체험실 목록

    private var roomListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("체험실 목록")
                    .font(AppTheme.subtitleFont)
                    .foregroundStyle(AppTheme.textPrimary)
                Spacer()
                Text("\(currentRooms.count)개")
                    .font(AppTheme.captionFont)
                    .foregroundStyle(AppTheme.textSecondary)
            }

            // 층별로 그룹화
            let grouped = groupedByFloor
            ForEach(grouped.keys.sorted(), id: \.self) { floor in
                VStack(alignment: .leading, spacing: 8) {
                    // 층 헤더
                    Text(floor)
                        .font(AppTheme.captionFont)
                        .fontWeight(.bold)
                        .foregroundStyle(selectedHall.themeColor)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(selectedHall.themeColor.opacity(0.1))
                        .clipShape(Capsule())

                    ForEach(grouped[floor] ?? []) { room in
                        roomRow(room)
                    }
                }
            }
        }
    }

    private func roomRow(_ room: ExperienceRoom) -> some View {
        HStack(spacing: 12) {
            Text(room.icon)
                .font(.title3)
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(room.name)
                        .font(AppTheme.bodyFont)
                        .foregroundStyle(AppTheme.textPrimary)
                    if room.isPopular {
                        Image(systemName: "star.fill")
                            .font(.caption2)
                            .foregroundStyle(AppTheme.accent)
                    }
                }
                Text("\(room.duration)분 • \(room.capacity)명 • \(ageRangeText(room))")
                    .font(AppTheme.captionFont)
                    .foregroundStyle(AppTheme.textSecondary)
            }

            Spacer()

            if room.joyCurrency != 0 {
                Text("\(room.joyCurrency > 0 ? "+" : "")\(room.joyCurrency)")
                    .font(AppTheme.captionFont)
                    .fontWeight(.bold)
                    .foregroundStyle(room.joyCurrency > 0 ? AppTheme.success : AppTheme.warning)
            }
        }
        .padding(.vertical, 6)
        .padding(.horizontal, AppTheme.paddingMedium)
        .background(AppTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius, style: .continuous))
    }

    // MARK: - 헬퍼

    private var currentRooms: [ExperienceRoom] {
        ScheduleData.rooms(for: selectedHall)
    }

    private var groupedByFloor: [String: [ExperienceRoom]] {
        Dictionary(grouping: currentRooms) { $0.floor }
    }

    private func ageRangeText(_ room: ExperienceRoom) -> String {
        let minYears = room.minAge / 12
        let maxYears = room.maxAge / 12
        return "\(minYears)~\(maxYears)세"
    }
}
