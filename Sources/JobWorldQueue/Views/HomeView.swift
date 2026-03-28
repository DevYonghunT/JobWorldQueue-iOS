// HomeView.swift
// 홈 화면 — 체험관 선택 및 메인 대시보드

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var routeEngine: RouteEngine
    @State private var selectedHall: HallType?

    /// 표시할 체험관 목록 (6개)
    private let halls: [HallType] = HallType.allCases

    /// 2열 그리드 레이아웃
    private let columns = [
        GridItem(.flexible(), spacing: AppTheme.paddingMedium),
        GridItem(.flexible(), spacing: AppTheme.paddingMedium),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.paddingLarge) {
                // 헤더 인사말
                headerSection

                // 오늘 운영 상태
                operatingStatusBanner

                // 체험관 카드 그리드
                hallCardsGrid

                // 빠른 시작 버튼
                if !routeEngine.activeRoute.isEmpty {
                    activeRouteCard
                }
            }
            .padding(.horizontal, AppTheme.paddingMedium)
            .padding(.top, AppTheme.paddingMedium)
            .padding(.bottom, 100)
        }
        .background(AppTheme.background.ignoresSafeArea())
        .navigationTitle("")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .navigationDestination(item: $selectedHall) { hall in
            RouteSetupView(preselectedHall: hall)
        }
    }

    // MARK: - 헤더

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("잡월드에 오신 걸\n환영합니다! 👋")
                .font(AppTheme.titleFont)
                .foregroundStyle(AppTheme.textPrimary)

            Text("체험할 관을 선택하고 최적 루트를 만들어보세요")
                .font(AppTheme.bodyFont)
                .foregroundStyle(AppTheme.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, AppTheme.paddingMedium)
    }

    // MARK: - 운영 상태 배너

    private var operatingStatusBanner: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(ScheduleData.isTodayOperating ? AppTheme.success : AppTheme.error)
                .frame(width: 10, height: 10)

            Text(ScheduleData.isTodayOperating ? "오늘 운영 중" : "오늘 휴관일 (월요일)")
                .font(AppTheme.captionFont)
                .foregroundStyle(AppTheme.textPrimary)

            Spacer()

            Text(currentTimeString())
                .font(AppTheme.captionFont)
                .foregroundStyle(AppTheme.textSecondary)
        }
        .padding(AppTheme.paddingMedium)
        .background(AppTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius, style: .continuous))
        .shadow(color: AppTheme.cardShadow, radius: 4, x: 0, y: 2)
    }

    // MARK: - 체험관 카드 그리드

    private var hallCardsGrid: some View {
        LazyVGrid(columns: columns, spacing: AppTheme.paddingMedium) {
            ForEach(halls, id: \.self) { hall in
                HallCard(hall: hall) {
                    selectedHall = hall
                }
            }
        }
    }

    // MARK: - 활성 루트 카드

    private var activeRouteCard: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "route.fill")
                    .foregroundStyle(AppTheme.primary)
                Text("진행 중인 코스")
                    .font(AppTheme.subtitleFont)
                    .foregroundStyle(AppTheme.textPrimary)
                Spacer()
            }

            if let current = routeEngine.currentItem {
                HStack {
                    Text(current.icon)
                        .font(.title2)
                    VStack(alignment: .leading) {
                        Text(current.roomName)
                            .font(AppTheme.bodyFont)
                            .fontWeight(.semibold)
                        Text("\(current.scheduledStartTime) • \(current.floor)")
                            .font(AppTheme.captionFont)
                            .foregroundStyle(AppTheme.textSecondary)
                    }
                    Spacer()
                    Text("\(routeEngine.completedCount)/\(routeEngine.activeRoute.count)")
                        .font(AppTheme.captionFont)
                        .foregroundStyle(AppTheme.textSecondary)
                }
            }

            // 진행 바
            ProgressView(value: routeEngine.progress)
                .tint(AppTheme.primary)
        }
        .padding(AppTheme.paddingMedium)
        .cardStyle()
    }

    // MARK: - 헬퍼

    private func currentTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date())
    }
}

// MARK: - HallType을 NavigationDestination에서 사용하기 위한 준비

extension HallType: Identifiable {
    var id: String { rawValue }
}
