---
name: clean-presentation-layer
description: Use when writing a ViewModel, a SwiftUI Screen or View, or a Swinject DI registration in a package's `Presentation` folder. Triggers on "добавь ViewModel", "экран", "presentation слой", "@InjectedStateObject", Container+register…, or any file under template-kit/Sources/<Feature>/Sources/Presentation.
---

# Presentation Layer (Swift)

Three things live here: the DI registration (`External/Container+register<Feature>Module.swift`),
ViewModels (`Internal/View/Models/`), and SwiftUI views split as `External/View/<Feature>Screen.swift`
(public) and `Internal/View/<Feature>View.swift` (internal).

**The folder is the visibility**: `External/` is what other packages may import, `Internal/` is not.
A ViewModel is internal, so it lives in `Internal/View/Models/`; the one that another package's host
resolves — `SplashViewModel` — is `public` and therefore sits in `External/View/Models/`.

## Screen vs View

- `External/View/<Feature>Screen.swift` — **`public`**, with a `public init()`. It resolves the
  ViewModel, reads `state`, and passes navigation arguments down. This is the only type another
  package imports.
- `Internal/View/<Feature>View.swift` — **internal**, takes values and `Binding`s. No ViewModel,
  no DI, no `@InjectedStateObject`. That is what keeps it previewable.

One exception, and it is deliberate: a screen whose ViewModel must outlive it is itself a
values-and-closures view (`SplashScreen(error:onRetry:)`), and the host that survives longer holds
the ViewModel — see **DI** below.

```swift
public struct OtpScreen: View {
    @InjectedStateObject var viewModel: OtpViewModel

    private let phone: String
    private let sessionId: String

    /// `phone` and `sessionId` are navigation arguments carried by `AuthFlow.Otp`, not shared state.
    public init(phone: String, sessionId: String) {
        self.phone = phone
        self.sessionId = sessionId
    }

    public var body: some View {
        AuthView(phone: phone, otp: viewModel.otp, error: viewModel.state.error) {
            Button { viewModel.onSubmit(sessionId: sessionId) } label: { Text("Sign In") }
                .disabled(viewModel.state.isLoading)
        }
    }
}
```

Data that one step of a flow passes to the next travels in the destination and arrives as an `init`
argument. Never a shared object between two ViewModels.

## ViewModel — a bridge, not a brain

```swift
@MainActor
final class InitiateViewModel: ObservableObject {
    @Published private(set) var state = InitiateState()

    private let viewModel: TemplateShared.InitiateViewModel

    init(app: TemplateApp) {
        viewModel = app.di.initiateViewModel()

        viewModel.state.toPublisher()
            .receive(on: RunLoop.main)
            .catch { _ in Empty() }
            .map { InitiateState(from: $0) }
            .assign(to: &$state)
    }
    
    /// The one field the screen edits.
    var phone: Binding<String> {
        Binding(
            get: { self.state.phone },
            set: { self.viewModel.onPhoneUpdate(phone: $0) }
        )
    }

    func onSubmit() {
        viewModel.onSubmit()
    }
}
```

Non-negotiables:

- **`@MainActor final class … : ObservableObject`**, single `init(app: TemplateApp)`. The KMM view
  model comes from `app.di.<feature>ViewModel()` — the Swift-callable DI helper — never from
  `TemplateShared.<X>ViewModel(...)` built by hand.
- **The subscription is a mapping, nothing else**:
  `.map { State(from: $0) }.assign(to: &$state)`. No `sink` closure that assigns, no private
  `show(_:)`, no cached copy of the KMM state, no branching on what arrived. The moment a
  subscription grows a body, logic has moved from Kotlin into Swift — put it back in the KMM
  ViewModel or UseCase.
- **`assign(to:)` needs no `AnyCancellable`** — it ties the subscription to the `@Published`
  property. A ViewModel that only mirrors state therefore has no `cancellable` set at all. Keep one
  only where a stream cannot be assigned, i.e. events (see **Navigation** below).
- **`@Published private(set) var state = <State>()`** with all fields defaulted. Nothing seeds it
  from `viewModel.state.value`: the KMM ViewModel is bound as a `factory`, so a freshly resolved one
  always carries exactly the Kotlin defaults the Swift struct already mirrors.
- **An editable field is a `Binding<T>` property**, not a writable `state`. Import SwiftUI in the
  ViewModel and hand the screen a ready binding — `TextField("Phone", text: viewModel.phone)`. The
  getter reads `state`, the setter calls **the KMM intent for that field**
  (`onPhoneUpdate(phone:)`). One property per editable field, no `Binding(get:set:)` at the call
  site, no `$viewModel` projection.
- **Swift never assembles a KMM state object.** Every editable field has its own intent on the
  Kotlin ViewModel — `fun onPhoneUpdate(phone: String) = state.update { it.copy(phone = phone) }`.
  If the Kotlin side exposes only a whole-state `onStateChange(new:)`, add the per-field intent
  there instead of rebuilding the state here: Swift flattened `error` to a `String` on the way in
  and cannot produce the `Throwable` the copy needs, so it would have to read the live state back
  (`viewModel.state.value.doCopy(…)`) just to pass fields it does not own straight through. That
  detour is the signal the Kotlin ViewModel is missing a method — see `clean-data-layer`.
- **Intents are one-liners that forward.** No `try/catch`, no retry, no validation: the Kotlin
  ViewModel owns the `CoroutineExceptionHandler` and parks failures in `state.error`.

## Navigation

KMM owns the decision, Swift owns the presentation. An event stream has no state to assign to, so
this is the one subscription that ends in a `sink` — with `[weak self]`, stored in a
`Set<AnyCancellable>`, and with the `Empty` generics spelled out
(`Combine.Empty<NavigationEvent, Never>()`; a bare `Empty()` leaves `Failure` unbound and makes
`sink(receiveValue:)` ambiguous against SKIE's overload — a confusing error far from its cause).

`NavigationContext.events` is a single stream every subscriber sees, so **each ViewModel picks out
its own routes and ignores the rest**:

```swift
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
```

`default: break` is correct here, and only here: a splash route reaching the auth stack is not an
unhandled case, it is someone else's event.

The root graph starts on `.splash` and never computes the first destination itself — KMM's
`SplashViewModel` decides and navigates. Do not reintroduce a synchronous "which screen first?"
read on the Swift side.

## DI

```swift
@MainActor
public extension Container {
    func registerAuthModule() {
        register(InitiateViewModel.self) { resolver in
            InitiateViewModel(app: resolver.resolve(TemplateApp.self)!)
        }

        register(OtpViewModel.self) { resolver in
            OtpViewModel(app: resolver.resolve(TemplateApp.self)!)
        }
    }
}
```

- One `Container+register<Feature>Module.swift` per package, registering **only ViewModels**.
  `TemplateApp` itself is registered once, in `Core`'s `registerAppModule()` — that one *is*
  `.inObjectScope(.container)`, because a second `TemplateApp` means a second Kodein graph.
- **A ViewModel is a factory: no `.inObjectScope(…)` at all.** Every resolution builds a fresh one,
  and the `@StateObject` inside `InjectedStateObject` is what owns it. Swinject's default `.graph`
  already means "shared within one resolution, new per top-level resolve" — spelling it out adds
  nothing, and `.container` turns a ViewModel into a singleton that survives its screen and keeps
  replaying stale state into the next one.
- **Lifetime is a view-tree question, not a DI question.** When something must outlive a screen —
  a listener that has to keep running after its screen is gone — resolve it in a view that lives
  longer and pass values down. `NavigationGraphScreen` is the root and never leaves the tree, so it
  holds `SplashViewModel` and hands `SplashScreen` an `error` and an `onRetry` closure. Widening the
  DI scope would achieve the same lifetime by making the object immortal for every other caller too.
- Register the module in the app target's `AppDelegate`, after the modules it depends on.
- `@InjectedStateObject var viewModel: X` is the only resolution site. It resolves from
  `\.di` in the environment, so a screen used outside `.dependencyInjection(container)` traps with
  "X not injected" — that is the intended failure, not something to guard against.
- A ViewModel is `public` only when another package's host resolves it — `SplashViewModel` is the
  one case. Expose the values the host reads (`public var error`), not the state struct.

## Adding a package

A feature is an SPM target under `template-kit/Sources/<Feature>/`, mirroring the KMM feature
module. Wiring, in order: `Package.swift` (target func + entry in `targets:` + entry in the library
product's `targets:`), then `import TemplateKit<Feature>` and `di.register<Feature>Module()` in
`AppDelegate`. Missing the product entry is the one that fails late and confusingly. See the
`add-module` skill.

## Checklist

- [ ] `<Feature>Screen` is `public` with a `public init`; `<Feature>View` is internal and takes values
- [ ] ViewModel is `@MainActor final class`, `init(app: TemplateApp)`, KMM VM via `app.di.…ViewModel()`
- [ ] `state` is `@Published private(set)` with defaults; the subscription is `.map { … }.assign(to: &$state)`
- [ ] no `show(_:)`, no cached KMM state, no `cancellable` set in a state-only ViewModel
- [ ] each editable field is a `Binding<T>` property whose setter calls a per-field KMM intent
- [ ] event subscriptions use `sink` with `[weak self]` and `Combine.Empty<X, Never>()` spelled out
- [ ] no `try/catch`, no business branching in the ViewModel
- [ ] foreign navigation routes ignored with `default: break`
- [ ] ViewModel registered with no `.inObjectScope(…)`; long-lived objects hoisted to a longer-lived view
- [ ] module registered in `AppDelegate` and the target added to the library product
