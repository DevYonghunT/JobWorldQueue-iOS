// AppTheme.swift
// 앱 테마 — 밝고 동글동글한 디자인 토큰

import SwiftUI

struct AppTheme {
    // MARK: - 메인 컬러
    /// 코랄 레드 - 메인 포인트 색상
    static let primary = Color(hex: "#FF6B6B")
    /// 틸 - 보조 색상
    static let secondary = Color(hex: "#4ECDC4")
    /// 옐로우 - 강조 색상
    static let accent = Color(hex: "#FFE66D")
    /// 밝은 회색 - 배경
    static let background = Color(hex: "#F7F7F7")
    /// 흰색 - 표면
    static let surface = Color.white
    /// 진한 텍스트
    static let textPrimary = Color(hex: "#2D3436")
    /// 연한 텍스트
    static let textSecondary = Color(hex: "#636E72")

    // MARK: - 체험관 대표 색상
    /// 어린이체험관 - 오렌지/옐로우
    static let childrenColor = Color(hex: "#F5A623")
    /// 청소년체험관 - 블루
    static let youthColor = Color(hex: "#4A90D9")
    /// 미래직업관 - 그린
    static let futureColor = Color(hex: "#2ECC71")
    /// 숙련기술체험관 - 인디고
    static let skillsColor = Color(hex: "#3F51B5")

    // MARK: - 상태 색상
    /// 성공/완료
    static let success = Color(hex: "#2ECC71")
    /// 경고
    static let warning = Color(hex: "#F39C12")
    /// 실패/에러
    static let error = Color(hex: "#E74C3C")
    /// 비활성
    static let disabled = Color(hex: "#BDC3C7")

    // MARK: - 모서리 반경
    /// 큰 모서리 (카드, 시트)
    static let cornerRadius: CGFloat = 20
    /// 카드 모서리
    static let cardCornerRadius: CGFloat = 16
    /// 버튼 모서리
    static let buttonCornerRadius: CGFloat = 14
    /// 작은 요소 모서리
    static let smallCornerRadius: CGFloat = 10

    // MARK: - 그림자
    /// 카드 그림자
    static let cardShadow: Color = Color.black.opacity(0.08)
    static let cardShadowRadius: CGFloat = 10
    static let cardShadowY: CGFloat = 4

    // MARK: - 애니메이션
    /// 스프링 애니메이션
    static let springAnimation = Animation.spring(response: 0.4, dampingFraction: 0.8)
    /// 빠른 스프링
    static let quickSpring = Animation.spring(response: 0.3, dampingFraction: 0.7)
    /// 부드러운 전환
    static let smoothTransition = Animation.easeInOut(duration: 0.3)

    // MARK: - 간격
    static let paddingSmall: CGFloat = 8
    static let paddingMedium: CGFloat = 16
    static let paddingLarge: CGFloat = 24
    static let paddingXLarge: CGFloat = 32

    // MARK: - 폰트
    /// 대제목
    static let titleFont: Font = .system(size: 28, weight: .bold, design: .rounded)
    /// 부제목
    static let subtitleFont: Font = .system(size: 20, weight: .semibold, design: .rounded)
    /// 본문
    static let bodyFont: Font = .system(size: 16, weight: .regular, design: .rounded)
    /// 캡션
    static let captionFont: Font = .system(size: 13, weight: .medium, design: .rounded)
    /// 버튼 텍스트
    static let buttonFont: Font = .system(size: 16, weight: .bold, design: .rounded)
}

// MARK: - Color Extension (Hex 지원)

extension Color {
    /// 16진수 컬러 코드로 Color 생성
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a: UInt64
        let r: UInt64
        let g: UInt64
        let b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - View Modifier 확장

/// 카드 스타일 모디파이어
struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(AppTheme.surface)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius, style: .continuous))
            .shadow(color: AppTheme.cardShadow, radius: AppTheme.cardShadowRadius, x: 0, y: AppTheme.cardShadowY)
    }
}

/// 프라이머리 버튼 스타일 모디파이어
struct PrimaryButtonStyle: ViewModifier {
    let color: Color

    func body(content: Content) -> some View {
        content
            .font(AppTheme.buttonFont)
            .foregroundStyle(.white)
            .padding(.horizontal, AppTheme.paddingLarge)
            .padding(.vertical, AppTheme.paddingMedium)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.buttonCornerRadius, style: .continuous))
    }
}

extension View {
    /// 카드 스타일 적용
    func cardStyle() -> some View {
        modifier(CardStyle())
    }

    /// 프라이머리 버튼 스타일 적용
    func primaryButtonStyle(color: Color = AppTheme.primary) -> some View {
        modifier(PrimaryButtonStyle(color: color))
    }
}
