# template-apple

iOS application template built with SwiftUI + SPM + KMM (Kotlin Multiplatform Mobile).

## Project structure

```
template-apple/          ← Xcode app target source group
  AppDelegate.swift      ← DI container setup (Swinject), SDK init
  TemplateApp.swift      ← @main App (uses UIApplicationDelegateAdaptor)
  ContentView.swift      ← renders NavigationGraphScreen
template-kit/            ← SPM local package (feature modules)
  Sources/
    Core/                ← TemplateKitCore — DI container, ContentState<T>, InjectedStateObject
    Auth/                ← TemplateKitAuth — multi-step auth (InitiateScreen → OtpScreen)
    Splash/              ← TemplateKitSplash — splash screen + KMM SplashViewModel bridge
    Navigation/          ← TemplateKitNavigation — root nav graph, TabView skeleton
template-apple.xcodeproj/
```

The KMM XCFramework `TemplateShared.xcframework` is consumed from:
`../../../multiplatform/template-client/shared/build/XCFrameworks/debug/`

## Key identifiers (template values — will be replaced when forking)

| Identifier | Value |
|---|---|
| Xcode target / app slug | `template-apple` |
| SPM package slug | `template-kit` |
| Class prefix | `Template` |
| Bundle ID | `com.template.apple` |
| SPM library product | `TemplateKit` |
| KMM XCFramework | `TemplateShared` |
| KMM repo slug | `template-client` |

## Architecture notes

- **DI:** `AppDelegate` creates the Swinject `Container` and registers all modules. `TemplateApp` passes it to the view tree via `.dependencyInjection(appDelegate.di)`.
- **Navigation root:** `RootDestination` starts on `.splash`; KMM's `SplashViewModel` decides the first flow and navigates, and `NavigationGraphViewModel` maps `SplashFlow` events onto `.auth` / `.launch`. Every ViewModel sees every `NavigationContext.event` and ignores routes that are not its own.
- **Splash:** `NavigationGraphScreen` (the root, never leaves the view tree) holds `SplashViewModel` and passes `error` / `onRetry` into `SplashScreen` — the KMM view model must keep listening for login/logout after the splash is gone. ViewModels are plain factories in Swinject; lifetime comes from the view that owns them, not from an object scope.
- **Auth flow:** `AuthNavigationStack` wraps a `NavigationStack`. `NavigationViewModel` listens to KMM events and appends `OtpAuthDestination.otp(phone:sessionId:)`, the Swift half of `AuthFlow.Otp`.
- **KMM state bridge:** a Swift ViewModel keeps the last `TemplateShared` state and writes back with `doCopy(...)` — `error: Throwable?` flattens to `String?` one way only and cannot be rebuilt.
- **Tab navigation:** `AppTabView` (TabView) + `AppTabViewModel` manage the authenticated app shell. Extend `AppTab` and `AppTabView` when adding real feature modules.
- **ContentState<T>:** Universal `.loading | .success(T) | .failure(String)` enum in Core — for screens whose whole body is one of three mutually exclusive renderings. A screen that shows a spinner *and* content at once needs two fields, not this enum.

## Skills

- **`clean-domain-layer`** / **`clean-data-layer`** / **`clean-presentation-layer`** — the layer rules: what belongs in `Domain/`, `Data/` and `Presentation/` of a feature package, and what belongs in the KMM repo instead. Load the one you are writing.
- **`adapt-template`** — run this skill after forking to rename all template identifiers (project slug, class prefix, bundle ID, KMM path) to match the new application.
- **`add-module`** — scaffolds a new feature package (Domain/Data/Presentation) and wires `Package.swift` + AppDelegate DI. Delegates the layer rules to the three skills above.
