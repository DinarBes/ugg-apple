# ugg-apple

iOS application template built with SwiftUI + SPM + KMM (Kotlin Multiplatform Mobile).

## Project structure

```
ugg-apple/               ← Xcode app target source group
  AppDelegate.swift      ← DI container setup (Swinject), SDK init
  UggApp.swift           ← @main App (uses UIApplicationDelegateAdaptor)
  ContentView.swift      ← renders NavigationGraphScreen
ugg-kit/                 ← SPM local package (feature modules)
  Sources/
    Core/                ← UggKitCore — DI container, ContentState<T>, InjectedStateObject
    Auth/                ← UggKitAuth — multi-step auth (InitiateScreen → OtpScreen)
    Splash/              ← UggKitSplash — splash screen + KMM SplashViewModel bridge
    Navigation/          ← UggKitNavigation — root nav graph, TabView skeleton
ugg-apple.xcodeproj/
```

The KMM XCFramework `UggShared.xcframework` is consumed from:
`../../../multiplatform/ugg-client/shared/build/XCFrameworks/debug/`

## Key identifiers (adapted from the template)

| Identifier | Value |
|---|---|
| Xcode target / app slug | `ugg-apple` |
| SPM package slug | `ugg-kit` |
| Class prefix | `Ugg` (Kotlin classes from the framework keep `TemplateApp`, `TemplateCore`) |
| Bundle ID | `com.ugg.client` |
| SPM library product | `UggKit` |
| KMM XCFramework | `UggShared` |
| KMM repo slug | `ugg-client` |

## Architecture notes

- **DI:** `AppDelegate` creates the Swinject `Container` and registers all modules. `UggApp` passes it to the view tree via `.dependencyInjection(appDelegate.di)`.
- **Navigation root:** `RootDestination` starts on `.splash`; KMM's `SplashViewModel` decides the first flow and navigates, and `NavigationGraphViewModel` maps `SplashFlow` events onto `.auth` / `.launch`. Every ViewModel sees every `NavigationContext.event` and ignores routes that are not its own.
- **Splash:** `NavigationGraphScreen` (the root, never leaves the view tree) holds `SplashViewModel` and passes `error` / `onRetry` into `SplashScreen` — the KMM view model must keep listening for login/logout after the splash is gone. ViewModels are plain factories in Swinject; lifetime comes from the view that owns them, not from an object scope.
- **Auth flow:** `AuthNavigationStack` wraps a `NavigationStack`. `NavigationViewModel` listens to KMM events and appends `OtpAuthDestination.otp(phone:sessionId:)`, the Swift half of `AuthFlow.Otp`.
- **KMM state bridge:** a Swift ViewModel keeps the last `UggShared` state and writes back with `doCopy(...)` — `error: Throwable?` flattens to `String?` one way only and cannot be rebuilt.
- **Tab navigation:** `AppTabView` (TabView) + `AppTabViewModel` manage the authenticated app shell. Extend `AppTab` and `AppTabView` when adding real feature modules.
- **ContentState<T>:** Universal `.loading | .success(T) | .failure(String)` enum in Core — for screens whose whole body is one of three mutually exclusive renderings. A screen that shows a spinner *and* content at once needs two fields, not this enum.

## Skills

- **`clean-domain-layer`** / **`clean-data-layer`** / **`clean-presentation-layer`** — the layer rules: what belongs in `Domain/`, `Data/` and `Presentation/` of a feature package, and what belongs in the KMM repo instead. Load the one you are writing.
- **`adapt-template`** — run this skill after forking to rename all template identifiers (project slug, class prefix, bundle ID, KMM path) to match the new application.
- **`add-module`** — scaffolds a new feature package (Domain/Data/Presentation) and wires `Package.swift` + AppDelegate DI. Delegates the layer rules to the three skills above.
