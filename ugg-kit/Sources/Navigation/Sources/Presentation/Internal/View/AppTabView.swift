//
//  AppTabView.swift
//  ugg-kit
//

import SwiftUI

import UggKitCore
import UggKitHome
import UggKitProduct
import UggKitCart
import UggKitStores

/// The app shell: the system tab bar, a `NavigationStack` per tab.
struct AppTabView: View {
    @InjectedStateObject var appTabVM: AppTabViewModel

    var body: some View {
        TabView(selection: $appTabVM.tab) {
            NavigationStack(path: $appTabVM.homePath) {
                HomeScreen(
                    onChooseModel: { appTabVM.select(.model) },
                    onOpenStores: { appTabVM.select(.stores) },
                    onOpenStory: { appTabVM.open(.story) },
                    onOpenCare: { appTabVM.open(.care) },
                    onOpenCart: { appTabVM.open(.cart) }
                )
                .appDestinations(appTabVM)
            }
            .tag(AppTab.home)
            .tabItem { Label("Главная", systemImage: UggIcon.home.rawValue) }

            NavigationStack(path: $appTabVM.modelPath) {
                ProductScreen(onAddToCart: { appTabVM.open(.cart) }).appDestinations(appTabVM)
            }
            .tag(AppTab.model)
            .tabItem { Label("Модель", systemImage: UggIcon.boot.rawValue) }

            NavigationStack(path: $appTabVM.storesPath) {
                StoresScreen().appDestinations(appTabVM)
            }
            .tag(AppTab.stores)
            .tabItem { Label("Точки", systemImage: UggIcon.pin.rawValue) }

            NavigationStack(path: $appTabVM.profilePath) {
                ComingSoonView(title: "Профиль").appDestinations(appTabVM)
            }
            .tag(AppTab.profile)
            .tabItem { Label("Профиль", systemImage: UggIcon.user.rawValue) }
        }
    }
}

private extension View {
    func appDestinations(_ appTabVM: AppTabViewModel) -> some View {
        navigationDestination(for: AppDestination.self) { destination in
            switch destination {
                case .story: ComingSoonView(title: "История")
                case .care: ComingSoonView(title: "Уход за уггами")
                case .cart:
                    CartScreen(
                        onChooseModel: { appTabVM.popAndSelect(.model) },
                        onSignIn: { appTabVM.signIn() },
                        onOpenOrders: { appTabVM.popAndSelect(.profile) }
                    )
            }
        }
    }
}

/// Stand-in for a screen of the next steps of the iOS port.
private struct ComingSoonView: View {
    let title: String

    var body: some View {
        VStack(spacing: UggSpacing.s) {
            Text(title).uggFont(.displayL).foregroundStyle(UggColors.content)
            Text("Экран скоро появится в iOS-версии")
                .uggFont(.body)
                .foregroundStyle(UggColors.contentSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(UggColors.background.ignoresSafeArea())
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
