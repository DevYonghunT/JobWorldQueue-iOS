// TabBar.swift
// 커스텀 하단 탭바 컴포넌트 — 부드러운 인디케이터 애니메이션

import SwiftUI

struct TabBar: View {
    @Binding var selectedTab: AppTab

    /// 탭바 탭 목록
    private let tabs = AppTab.allCases

    /// 탭바 아이템 네임스페이스 (매칭 지오메트리용)
    @Namespace private var tabNamespace

    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.self) { tab in
                tabItem(tab)
            }
        }
        .padding(.horizontal, AppTheme.paddingMedium)
        .padding(.top, 12)
        .padding(.bottom, 24)
        .background(
            AppTheme.surface
                .clipShape(
                    RoundedRectangle(cornerRadius: AppTheme.cornerRadius, style: .continuous)
                )
                .shadow(color: AppTheme.cardShadow, radius: 12, x: 0, y: -4)
                .ignoresSafeArea(.all, edges: .bottom)
        )
    }

    // MARK: - 탭 아이템

    private func tabItem(_ tab: AppTab) -> some View {
        Button {
            withAnimation(AppTheme.springAnimation) {
                selectedTab = tab
            }
        } label: {
            VStack(spacing: 4) {
                // 선택 인디케이터
                ZStack {
                    if selectedTab == tab {
                        Capsule()
                            .fill(AppTheme.primary.opacity(0.15))
                            .frame(width: 56, height: 32)
                            .matchedGeometryEffect(id: "tabIndicator", in: tabNamespace)
                    }

                    Image(systemName: tab.icon)
                        .font(.system(size: 18, weight: selectedTab == tab ? .bold : .regular))
                        .foregroundStyle(
                            selectedTab == tab ? AppTheme.primary : AppTheme.textSecondary
                        )
                }
                .frame(height: 32)

                // 탭 이름
                Text(tab.rawValue)
                    .font(.system(size: 10, weight: selectedTab == tab ? .bold : .regular, design: .rounded))
                    .foregroundStyle(
                        selectedTab == tab ? AppTheme.primary : AppTheme.textSecondary
                    )
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}
