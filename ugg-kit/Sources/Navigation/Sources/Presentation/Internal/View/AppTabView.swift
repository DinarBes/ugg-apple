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
import UggKitProfile
import UggKitCare
import UggKitStory

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
                ProfileScreen(
                    onSignIn: { appTabVM.signIn() },
                    onOpenSettings: { appTabVM.open(.settings) },
                    onOpenSize: { appTabVM.open(.size) },
                    // TODO: the orders list; the active order card is on the profile for now.
                    onOpenOrders: { },
                    onOpenAddresses: { appTabVM.open(.addresses) },
                    onOpenCare: { appTabVM.open(.care) }
                )
                .appDestinations(appTabVM)
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
                case .story: StoryScreen(onChooseModel: { appTabVM.popAndSelect(.model) })
                case .care: CareScreen()
                case .settings: SettingsScreen()
                case .name: NameScreen()
                case .size: SizeScreen()
                case .addresses: AddressesScreen()
                case .addressForm(let id): AddressFormScreen(addressId: id)
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
