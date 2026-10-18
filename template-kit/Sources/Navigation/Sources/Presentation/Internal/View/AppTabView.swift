//
//  AppTabView.swift
//  template-kit
//

import SwiftUI

import TemplateKitCore

struct AppTabView: View {
    @InjectedStateObject var appTabVM: AppTabViewModel

    var body: some View {
        TabView(selection: $appTabVM.tab) {
            Text("Home")
                .tag(AppTab.home)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            Text("Profile")
                .tag(AppTab.profile)
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
}
