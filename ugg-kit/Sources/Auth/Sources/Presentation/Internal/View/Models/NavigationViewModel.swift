//
//  NavigationViewModel.swift
//  ugg-kit
//

import Combine
import SwiftUI

import UggShared

@MainActor
final class NavigationViewModel: ObservableObject {
    @Published var path = NavigationPath()

    private var cancellable: Set<AnyCancellable> = []

    init(app: TemplateApp) {
        app.navigationContext.events.toPublisher()
            .receive(on: RunLoop.main)
            .catch { _ in Combine.Empty<NavigationEvent, Never>() }
            .sink { [weak self] event in
                self?.handle(event: event)
            }
            .store(in: &cancellable)
    }

    private func handle(event: NavigationEvent) {
        switch onEnum(of: event) {
            case .onNavigate(let nav):
                navigate(route: nav.route)
            case .onBack:
                if !path.isEmpty { path.removeLast() }
        }
    }

    private func navigate(route: Destination) {
        switch route {
            case let otp as AuthFlow.Otp:
                path.append(OtpAuthDestination.otp(phone: otp.phone, sessionId: otp.sessionId))
            default:
                break
        }
    }
}
