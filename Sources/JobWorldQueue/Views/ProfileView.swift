// ProfileView.swift
// 마이페이지 — 사용자 정보 및 체험 기록

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var routeEngine: RouteEngine
    @State private var userName: String = "방문자"
    @State private var userAge: Int = 7

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.paddingLarge) {
                // 프로필 헤더
                profileHeader

                // 통계 카드
                statsCards

                // 설정 섹션
                settingsSection

                // 앱 정보
                appInfoSection
            }
            .padding(.horizontal, AppTheme.paddingMedium)
            .padding(.top, AppTheme.paddingMedium)
            .padding(.bottom, 100)
        }
        .background(AppTheme.background.ignoresSafeArea())
        .navigationTitle("마이페이지")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.large)
        #endif
    }

    // MARK: - 프로필 헤더

    private var profileHeader: some View {
        VStack(spacing: 16) {
            // 아바타
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AppTheme.primary, AppTheme.secondary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)

                Image(systemName: "person.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(.white)
            }

            VStack(spacing: 4) {
                Text(userName)
                    .font(AppTheme.subtitleFont)
                    .foregroundStyle(AppTheme.textPrimary)

                Text("\(userAge)세")
                    .font(AppTheme.captionFont)
                    .foregroundStyle(AppTheme.textSecondary)
            }

            // JOY 잔액
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .foregroundStyle(AppTheme.accent)
                Text("JOY")
                    .font(AppTheme.captionFont)
                    .foregroundStyle(AppTheme.accent)
                Text("\(routeEngine.totalJoy)")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(AppTheme.textPrimary)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(AppTheme.accent.opacity(0.15))
            .clipShape(Capsule())
        }
        .frame(maxWidth: .infinity)
        .padding(AppTheme.paddingLarge)
        .cardStyle()
    }

    // MARK: - 통계 카드

    private var statsCards: some View {
        HStack(spacing: AppTheme.paddingMedium) {
            statCard(
                title: "완료 체험",
                value: "\(routeEngine.completedCount)",
                icon: "checkmark.circle.fill",
                color: AppTheme.success
            )

            statCard(
                title: "진행 루트",
                value: routeEngine.activeRoute.isEmpty ? "0" : "1",
                icon: "route.fill",
                color: AppTheme.primary
            )

            statCard(
                title: "남은 체험",
                value: "\(routeEngine.remainingCount)",
                icon: "hourglass",
                color: AppTheme.secondary
            )
        }
    }

    private func statCard(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)

            Text(value)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(AppTheme.textPrimary)

            Text(title)
                .font(AppTheme.captionFont)
                .foregroundStyle(AppTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(AppTheme.paddingMedium)
        .cardStyle()
    }

    // MARK: - 설정 섹션

    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("설정")
                .font(AppTheme.subtitleFont)
                .foregroundStyle(AppTheme.textPrimary)

            VStack(spacing: 0) {
                settingRow(icon: "person.fill", title: "이름 변경", color: AppTheme.primary)
                Divider().padding(.leading, 48)
                settingRow(icon: "calendar", title: "나이 변경", color: AppTheme.secondary)
                Divider().padding(.leading, 48)
                settingRow(icon: "bell.fill", title: "알림 설정", color: AppTheme.warning)
                Divider().padding(.leading, 48)
                settingRow(icon: "arrow.counterclockwise", title: "코스 초기화", color: AppTheme.error)
            }
            .padding(.vertical, 4)
            .cardStyle()
        }
    }

    private func settingRow(icon: String, title: String, color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.body)
                .foregroundStyle(color)
                .frame(width: 28)

            Text(title)
                .font(AppTheme.bodyFont)
                .foregroundStyle(AppTheme.textPrimary)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(AppTheme.textSecondary)
        }
        .padding(.horizontal, AppTheme.paddingMedium)
        .padding(.vertical, 12)
    }

    // MARK: - 앱 정보

    private var appInfoSection: some View {
        VStack(spacing: 8) {
            Text("JobWorldQueue")
                .font(AppTheme.captionFont)
                .fontWeight(.bold)
                .foregroundStyle(AppTheme.textSecondary)

            Text("잡월드 체험 최적 루트 앱")
                .font(AppTheme.captionFont)
                .foregroundStyle(AppTheme.textSecondary)

            Text("v1.0.0")
                .font(AppTheme.captionFont)
                .foregroundStyle(AppTheme.disabled)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, AppTheme.paddingMedium)
    }
}
