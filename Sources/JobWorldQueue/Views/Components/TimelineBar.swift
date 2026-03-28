// TimelineBar.swift
// 타임라인 바 컴포넌트 — 다음 체험 미리보기

import SwiftUI

struct TimelineBar: View {
    let item: RouteItem
    let hallColor: Color

    var body: some View {
        HStack(spacing: 12) {
            // 타임라인 연결선 + 점
            VStack(spacing: 0) {
                Rectangle()
                    .fill(hallColor.opacity(0.3))
                    .frame(width: 2)

                Circle()
                    .fill(hallColor.opacity(0.5))
                    .frame(width: 10, height: 10)

                Rectangle()
                    .fill(hallColor.opacity(0.3))
                    .frame(width: 2)
            }
            .frame(width: 10)

            // 시간
            Text(item.scheduledStartTime)
                .font(.system(size: 14, weight: .medium, design: .monospaced))
                .foregroundStyle(AppTheme.textSecondary)
                .frame(width: 50, alignment: .leading)

            // 아이콘
            Text(item.icon)
                .font(.title3)
                .frame(width: 32, height: 32)
                .background(hallColor.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

            // 정보
            VStack(alignment: .leading, spacing: 2) {
                Text(item.roomName)
                    .font(AppTheme.bodyFont)
                    .foregroundStyle(AppTheme.textPrimary)
                    .lineLimit(1)

                HStack(spacing: 6) {
                    Label(item.floor, systemImage: "building.2")
                    Label("\(item.estimatedDuration)분", systemImage: "timer")
                }
                .font(.system(size: 11, weight: .regular, design: .rounded))
                .foregroundStyle(AppTheme.textSecondary)
            }

            Spacer()

            // JOY
            if item.joyCurrency != 0 {
                Text("\(item.joyCurrency > 0 ? "+" : "")\(item.joyCurrency)")
                    .font(AppTheme.captionFont)
                    .fontWeight(.semibold)
                    .foregroundStyle(item.joyCurrency > 0 ? AppTheme.success : AppTheme.warning)
            }
        }
        .padding(.vertical, 6)
        .padding(.horizontal, AppTheme.paddingMedium)
        .background(AppTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius, style: .continuous))
        .shadow(color: AppTheme.cardShadow, radius: 4, x: 0, y: 2)
    }
}
