// JobWorldQueueApp.swift
// 잡월드 체험 최적 루트 앱 - 메인 엔트리포인트

import SwiftUI

@main
struct JobWorldQueueApp: App {
    @StateObject private var routeEngine = RouteEngine()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(routeEngine)
        }
    }
}

/// 루트 탭 네비게이션을 관리하는 메인 컨텐츠 뷰
struct ContentView: View {
    @State private var selectedTab: AppTab = .home
    @EnvironmentObject var routeEngine: RouteEngine

    var body: some View {
        ZStack(alignment: .bottom) {
            // 탭별 콘텐츠
            Group {
                switch selectedTab {
                case .home:
                    NavigationStack {
                        HomeView()
                    }
                case .timetable:
                    NavigationStack {
                        TimetableView()
                    }
                case .route:
                    NavigationStack {
                        if routeEngine.activeRoute.isEmpty {
                            RouteSetupView()
                        } else {
                            ActiveRouteView()
                        }
                    }
                case .profile:
                    NavigationStack {
                        ProfileView()
                    }
                }
            }
            .padding(.bottom, 80)

            // 커스텀 탭바
            TabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(.keyboard)
    }
}

/// 앱 탭 열거형
enum AppTab: String, CaseIterable {
    case home = "홈"
    case timetable = "시간표"
    case route = "코스"
    case profile = "프로필"

    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .timetable: return "clock.fill"
        case .route: return "map.fill"
        case .profile: return "person.fill"
        }
    }
}
