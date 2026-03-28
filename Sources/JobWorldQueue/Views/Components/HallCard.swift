// HallCard.swift
// 체험관 카드 컴포넌트 — 홈 화면에서 체험관 선택용

import SwiftUI

struct HallCard: View {
    let hall: HallType
    let action: () -> Void

    @State private var isPressed: Bool = false

    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                // 아이콘
                ZStack {
                    Circle()
                        .fill(hall.themeColor.opacity(0.15))
                        .frame(width: 56, height: 56)

                    Image(systemName: hall.icon)
                        .font(.system(size: 24))
                        .foregroundStyle(hall.themeColor)
                }

                // 체험관 이름
                Text(hall.shortName)
                    .font(AppTheme.bodyFont)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppTheme.textPrimary)

                // 설명
                Text(hall.description)
                    .font(.system(size: 11, weight: .regular, design: .rounded))
                    .foregroundStyle(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .padding(AppTheme.paddingMedium)
            .background(AppTheme.surface)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius, style: .continuous))
            .shadow(
                color: hall.themeColor.opacity(isPressed ? 0.3 : 0.1),
                radius: isPressed ? 6 : AppTheme.cardShadowRadius,
                x: 0,
                y: isPressed ? 2 : AppTheme.cardShadowY
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius, style: .continuous)
                    .stroke(hall.themeColor.opacity(0.2), lineWidth: 1)
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(AppTheme.quickSpring, value: isPressed)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}
