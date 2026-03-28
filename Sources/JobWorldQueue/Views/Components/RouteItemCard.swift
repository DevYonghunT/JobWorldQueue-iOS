// RouteItemCard.swift
// 루트 아이템 카드 컴포넌트 — 전체 루트 목록에서 사용

import SwiftUI

struct RouteItemCard: View {
    let item: RouteItem
    let hallColor: Color

    var body: some View {
        HStack(spacing: 12) {
            // 순서 번호 + 상태 인디케이터
            ZStack {
                Circle()
                    .fill(statusColor.opacity(0.15))
                    .frame(width: 36, height: 36)

                if item.status == .completed {
                    Image(systemName: "checkmark")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(statusColor)
                } else if item.status == .failed || item.status == .skipped {
                    Image(systemName: item.status == .failed ? "xmark" : "forward.fill")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(statusColor)
                } else {
                    Text("\(item.order + 1)")
                        .font(AppTheme.captionFont)
                        .fontWeight(.bold)
                        .foregroundStyle(statusColor)
                }
            }

            // 아이콘
            Text(item.icon)
                .font(.title3)

            // 정보
            VStack(alignment: .leading, spacing: 2) {
                Text(item.roomName)
                    .font(AppTheme.bodyFont)
                    .fontWeight(item.status == .active ? .semibold : .regular)
                    .foregroundStyle(
                        item.status == .completed || item.status == .skipped
                            ? AppTheme.textSecondary
                            : AppTheme.textPrimary
                    )
                    .strikethrough(item.status == .skipped || item.status == .failed)

                HStack(spacing: 8) {
                    Text(item.scheduledStartTime)
                    Text("•")
                    Text(item.floor)
                    Text("•")
                    Text("\(item.estimatedDuration)분")
                }
                .font(AppTheme.captionFont)
                .foregroundStyle(AppTheme.textSecondary)
            }

            Spacer()

            // 상태 배지
            Text(item.status.rawValue)
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundStyle(statusColor)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(statusColor.opacity(0.1))
                .clipShape(Capsule())
        }
        .padding(.horizontal, AppTheme.paddingMedium)
        .padding(.vertical, 10)
        .background(
            item.status == .active
                ? hallColor.opacity(0.05)
                : AppTheme.surface
        )
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius, style: .continuous)
                .stroke(
                    item.status == .active ? hallColor.opacity(0.3) : Color.clear,
                    lineWidth: 1.5
                )
        )
    }

    /// 상태별 색상
    private var statusColor: Color {
        switch item.status {
        case .pending: return AppTheme.textSecondary
        case .active: return hallColor
        case .completed: return AppTheme.success
        case .skipped: return AppTheme.warning
        case .failed: return AppTheme.error
        }
    }
}
