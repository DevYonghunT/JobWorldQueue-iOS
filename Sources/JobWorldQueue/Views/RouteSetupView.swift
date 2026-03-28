// RouteSetupView.swift
// 루트 설정 화면 — 나이, 체험관, 선호도 선택

import SwiftUI

struct RouteSetupView: View {
    @EnvironmentObject var routeEngine: RouteEngine
    @Environment(\.dismiss) private var dismiss

    /// 미리 선택된 체험관 (홈에서 넘어올 때)
    var preselectedHall: HallType?

    @State private var selectedHall: HallType = .children
    @State private var ageYears: Int = 7
    @State private var selectedRoomIds: Set<String> = []
    @State private var sessionCount: Int = 5
    @State private var showRoomPicker: Bool = false

    /// 현재 선택된 체험관의 체험실 목록
    private var availableRooms: [ExperienceRoom] {
        ScheduleData.rooms(for: selectedHall)
            .filter { $0.isAgeEligible(ageInMonths: ageYears * 12) }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.paddingLarge) {
                // 체험관 선택
                hallSelectionSection

                // 나이 설정
                ageSelectionSection

                // 체험 수 설정
                sessionCountSection

                // 선호 체험실 선택
                preferredRoomsSection

                // 루트 생성 버튼
                generateButton
            }
            .padding(.horizontal, AppTheme.paddingMedium)
            .padding(.top, AppTheme.paddingMedium)
            .padding(.bottom, 100)
        }
        .background(AppTheme.background.ignoresSafeArea())
        .navigationTitle("코스 설정")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.large)
        #endif
        .onAppear {
            if let hall = preselectedHall {
                selectedHall = hall
            }
        }
        .sheet(isPresented: $showRoomPicker) {
            roomPickerSheet
        }
    }

    // MARK: - 체험관 선택

    private var hallSelectionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("체험관 선택")
                .font(AppTheme.subtitleFont)
                .foregroundStyle(AppTheme.textPrimary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach([HallType.children, .youth, .future, .skills], id: \.self) { hall in
                        hallChip(hall)
                    }
                }
            }
        }
    }

    private func hallChip(_ hall: HallType) -> some View {
        Button {
            withAnimation(AppTheme.quickSpring) {
                selectedHall = hall
                selectedRoomIds = []
            }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: hall.icon)
                    .font(.body)
                Text(hall.shortName)
                    .font(AppTheme.captionFont)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(selectedHall == hall ? hall.themeColor : AppTheme.surface)
            .foregroundStyle(selectedHall == hall ? .white : AppTheme.textPrimary)
            .clipShape(Capsule())
            .shadow(color: AppTheme.cardShadow, radius: 4, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }

    // MARK: - 나이 설정

    private var ageSelectionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("나이")
                .font(AppTheme.subtitleFont)
                .foregroundStyle(AppTheme.textPrimary)

            HStack {
                Button {
                    if ageYears > 3 { ageYears -= 1 }
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(AppTheme.textSecondary)
                }

                Spacer()

                Text("\(ageYears)세")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundStyle(AppTheme.textPrimary)

                Spacer()

                Button {
                    if ageYears < 18 { ageYears += 1 }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(AppTheme.textSecondary)
                }
            }
            .padding(AppTheme.paddingMedium)
            .background(AppTheme.surface)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius, style: .continuous))
            .shadow(color: AppTheme.cardShadow, radius: 4, x: 0, y: 2)

            // 이용 가능 체험실 수 표시
            Text("이용 가능 체험실: \(availableRooms.count)개")
                .font(AppTheme.captionFont)
                .foregroundStyle(AppTheme.textSecondary)
        }
    }

    // MARK: - 체험 수 설정

    private var sessionCountSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("체험 수")
                .font(AppTheme.subtitleFont)
                .foregroundStyle(AppTheme.textPrimary)

            HStack(spacing: 12) {
                ForEach([3, 4, 5], id: \.self) { count in
                    Button {
                        withAnimation(AppTheme.quickSpring) {
                            sessionCount = count
                        }
                    } label: {
                        Text("\(count)개")
                            .font(AppTheme.buttonFont)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(sessionCount == count ? AppTheme.secondary : AppTheme.surface)
                            .foregroundStyle(sessionCount == count ? .white : AppTheme.textPrimary)
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.buttonCornerRadius, style: .continuous))
                            .shadow(color: AppTheme.cardShadow, radius: 4, x: 0, y: 2)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - 선호 체험실

    private var preferredRoomsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("선호 체험실")
                    .font(AppTheme.subtitleFont)
                    .foregroundStyle(AppTheme.textPrimary)

                Spacer()

                Button("추가") {
                    showRoomPicker = true
                }
                .font(AppTheme.captionFont)
                .foregroundStyle(AppTheme.primary)
            }

            if selectedRoomIds.isEmpty {
                Text("선호 체험실을 추가하면 우선 배치됩니다")
                    .font(AppTheme.captionFont)
                    .foregroundStyle(AppTheme.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(AppTheme.paddingLarge)
                    .background(AppTheme.surface)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius, style: .continuous))
            } else {
                FlowLayout(spacing: 8) {
                    ForEach(selectedRoomChips, id: \.id) { room in
                        HStack(spacing: 4) {
                            Text(room.icon)
                                .font(.caption)
                            Text(room.name)
                                .font(AppTheme.captionFont)
                            Button {
                                selectedRoomIds.remove(room.id)
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.caption)
                                    .foregroundStyle(AppTheme.textSecondary)
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(selectedHall.themeColor.opacity(0.15))
                        .clipShape(Capsule())
                    }
                }
            }
        }
    }

    private var selectedRoomChips: [ExperienceRoom] {
        availableRooms.filter { selectedRoomIds.contains($0.id) }
    }

    // MARK: - 체험실 선택 시트

    private var roomPickerSheet: some View {
        NavigationStack {
            List(availableRooms) { room in
                Button {
                    if selectedRoomIds.contains(room.id) {
                        selectedRoomIds.remove(room.id)
                    } else {
                        selectedRoomIds.insert(room.id)
                    }
                } label: {
                    HStack {
                        Text(room.icon)
                            .font(.title3)
                        VStack(alignment: .leading) {
                            Text(room.name)
                                .font(AppTheme.bodyFont)
                                .foregroundStyle(AppTheme.textPrimary)
                            Text("\(room.floor) • \(room.duration)분 • \(room.isPopular ? "인기" : "")")
                                .font(AppTheme.captionFont)
                                .foregroundStyle(AppTheme.textSecondary)
                        }
                        Spacer()
                        if selectedRoomIds.contains(room.id) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(AppTheme.success)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
            .navigationTitle("체험실 선택")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("완료") { showRoomPicker = false }
                }
            }
        }
    }

    // MARK: - 루트 생성 버튼

    private var generateButton: some View {
        Button {
            routeEngine.generateRoute(
                hall: selectedHall,
                ageInMonths: ageYears * 12,
                preferredIds: selectedRoomIds,
                sessionCount: sessionCount
            )
            dismiss()
        } label: {
            HStack {
                Image(systemName: "sparkles")
                Text("최적 루트 생성")
            }
            .frame(maxWidth: .infinity)
            .primaryButtonStyle(color: selectedHall.themeColor)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - FlowLayout (태그 칩용 래핑 레이아웃)

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = layout(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = layout(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y),
                proposal: .unspecified
            )
        }
    }

    private func layout(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX + size.width > maxWidth, currentX > 0 {
                currentX = 0
                currentY += lineHeight + spacing
                lineHeight = 0
            }
            positions.append(CGPoint(x: currentX, y: currentY))
            lineHeight = max(lineHeight, size.height)
            currentX += size.width + spacing
        }

        return (
            size: CGSize(width: maxWidth, height: currentY + lineHeight),
            positions: positions
        )
    }
}
