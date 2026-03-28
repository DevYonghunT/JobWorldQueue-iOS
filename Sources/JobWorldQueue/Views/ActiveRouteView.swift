// ActiveRouteView.swift
// 실행 중 루트 화면 — 체험 진행 메인 화면

import SwiftUI

struct ActiveRouteView: View {
    @EnvironmentObject var routeEngine: RouteEngine
    @State private var showResetAlert: Bool = false

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.paddingLarge) {
                // 진행 상태 헤더
                progressHeader

                // 현재 체험 카드 (크게)
                if let current = routeEngine.currentItem {
                    currentExperienceCard(current)
                }

                // 액션 버튼 (완료/실패)
                if routeEngine.currentItem != nil && !routeEngine.isRouteComplete {
                    actionButtons
                }

                // 루트 완료 카드
                if routeEngine.isRouteComplete {
                    routeCompleteCard
                }

                // 다음 체험 타임라인
                if !routeEngine.upcomingItems.isEmpty {
                    upcomingTimeline
                }

                // 전체 루트 목록
                fullRouteList
            }
            .padding(.horizontal, AppTheme.paddingMedium)
            .padding(.top, AppTheme.paddingMedium)
            .padding(.bottom, 100)
        }
        .background(AppTheme.background.ignoresSafeArea())
        .navigationTitle("진행 중 코스")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button {
                    showResetAlert = true
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                        .foregroundStyle(AppTheme.textSecondary)
                }
            }
        }
        .alert("코스 초기화", isPresented: $showResetAlert) {
            Button("초기화", role: .destructive) {
                routeEngine.resetRoute()
            }
            Button("취소", role: .cancel) {}
        } message: {
            Text("현재 진행 중인 코스를 초기화하시겠습니까?")
        }
    }

    // MARK: - 진행 상태 헤더

    private var progressHeader: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(routeEngine.selectedHall.displayName)
                        .font(AppTheme.subtitleFont)
                        .foregroundStyle(AppTheme.textPrimary)
                    Text("\(routeEngine.completedCount)/\(routeEngine.activeRoute.count) 체험 완료")
                        .font(AppTheme.captionFont)
                        .foregroundStyle(AppTheme.textSecondary)
                }
                Spacer()
                // JOY 표시
                HStack(spacing: 4) {
                    Text("JOY")
                        .font(AppTheme.captionFont)
                        .foregroundStyle(AppTheme.accent)
                    Text("\(routeEngine.totalJoy)")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(AppTheme.textPrimary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(AppTheme.accent.opacity(0.2))
                .clipShape(Capsule())
            }

            // 진행 바
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(AppTheme.disabled.opacity(0.3))
                        .frame(height: 12)

                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                colors: [AppTheme.primary, AppTheme.secondary],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * routeEngine.progress, height: 12)
                        .animation(AppTheme.springAnimation, value: routeEngine.progress)
                }
            }
            .frame(height: 12)

            // 남은 시간
            HStack {
                Image(systemName: "clock")
                    .font(.caption)
                Text("남은 시간: 약 \(routeEngine.remainingMinutes)분")
                    .font(AppTheme.captionFont)
                Spacer()
                Text("남은 체험: \(routeEngine.remainingCount)개")
                    .font(AppTheme.captionFont)
            }
            .foregroundStyle(AppTheme.textSecondary)
        }
        .padding(AppTheme.paddingMedium)
        .cardStyle()
    }

    // MARK: - 현재 체험 카드

    private func currentExperienceCard(_ item: RouteItem) -> some View {
        VStack(spacing: 16) {
            // 상태 라벨
            HStack {
                Circle()
                    .fill(AppTheme.primary)
                    .frame(width: 8, height: 8)
                Text("현재 체험")
                    .font(AppTheme.captionFont)
                    .foregroundStyle(AppTheme.primary)
                Spacer()
                Text(item.scheduledStartTime)
                    .font(AppTheme.captionFont)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppTheme.textSecondary)
            }

            // 메인 정보
            HStack(spacing: 16) {
                // 아이콘
                Text(item.icon)
                    .font(.system(size: 48))
                    .frame(width: 80, height: 80)
                    .background(routeEngine.selectedHall.themeColor.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius, style: .continuous))

                VStack(alignment: .leading, spacing: 6) {
                    Text(item.roomName)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(AppTheme.textPrimary)

                    HStack(spacing: 12) {
                        Label(item.floor, systemImage: "building.2")
                        Label("\(item.estimatedDuration)분", systemImage: "timer")
                    }
                    .font(AppTheme.captionFont)
                    .foregroundStyle(AppTheme.textSecondary)

                    if item.joyCurrency != 0 {
                        Text("JOY \(item.joyCurrency > 0 ? "+" : "")\(item.joyCurrency)")
                            .font(AppTheme.captionFont)
                            .fontWeight(.semibold)
                            .foregroundStyle(item.joyCurrency > 0 ? AppTheme.success : AppTheme.warning)
                    }
                }
                Spacer()
            }
        }
        .padding(AppTheme.paddingLarge)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.cornerRadius, style: .continuous)
                .fill(AppTheme.surface)
                .shadow(color: routeEngine.selectedHall.themeColor.opacity(0.2), radius: 12, x: 0, y: 6)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.cornerRadius, style: .continuous)
                .stroke(routeEngine.selectedHall.themeColor.opacity(0.3), lineWidth: 2)
        )
    }

    // MARK: - 액션 버튼

    private var actionButtons: some View {
        HStack(spacing: 16) {
            // 체험 실패 버튼
            Button {
                routeEngine.onExperienceFailed()
            } label: {
                HStack {
                    Image(systemName: "xmark")
                    Text("체험 실패")
                }
                .frame(maxWidth: .infinity)
                .primaryButtonStyle(color: AppTheme.error)
            }
            .buttonStyle(.plain)

            // 체험 완료 버튼
            Button {
                routeEngine.onExperienceSuccess()
            } label: {
                HStack {
                    Image(systemName: "checkmark")
                    Text("체험 완료!")
                }
                .frame(maxWidth: .infinity)
                .primaryButtonStyle(color: AppTheme.success)
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - 루트 완료 카드

    private var routeCompleteCard: some View {
        VStack(spacing: 16) {
            Image(systemName: "party.popper.fill")
                .font(.system(size: 48))
                .foregroundStyle(AppTheme.accent)

            Text("모든 체험 완료!")
                .font(AppTheme.titleFont)
                .foregroundStyle(AppTheme.textPrimary)

            Text("총 \(routeEngine.completedCount)개 체험, JOY \(routeEngine.totalJoy) 획득")
                .font(AppTheme.bodyFont)
                .foregroundStyle(AppTheme.textSecondary)

            Button {
                routeEngine.resetRoute()
            } label: {
                Text("새 코스 만들기")
                    .primaryButtonStyle(color: AppTheme.primary)
            }
            .buttonStyle(.plain)
        }
        .padding(AppTheme.paddingLarge)
        .frame(maxWidth: .infinity)
        .cardStyle()
    }

    // MARK: - 다음 체험 타임라인

    private var upcomingTimeline: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("다음 체험")
                .font(AppTheme.subtitleFont)
                .foregroundStyle(AppTheme.textPrimary)

            ForEach(routeEngine.upcomingItems) { item in
                TimelineBar(item: item, hallColor: routeEngine.selectedHall.themeColor)
            }
        }
    }

    // MARK: - 전체 루트 목록

    private var fullRouteList: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("전체 루트")
                .font(AppTheme.subtitleFont)
                .foregroundStyle(AppTheme.textPrimary)

            ForEach(routeEngine.activeRoute) { item in
                RouteItemCard(item: item, hallColor: routeEngine.selectedHall.themeColor)
            }
        }
    }
}
