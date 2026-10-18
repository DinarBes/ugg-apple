---
name: add-module
description: Use when the user wants to add a new feature package (SPM target) to the iOS template project — generates the Domain/Data/Presentation files and wires Package.swift and AppDelegate DI.
---

# Add Feature Package

Scaffold a feature as an SPM target under `template-kit/Sources/<Feature>/`, mirroring the KMM
feature module of the same name. The layer rules live in `clean-domain-layer`, `clean-data-layer`
and `clean-presentation-layer` — **load whichever layer you are writing**. This skill is only the
file list and the wiring.

**All identifiers are read from existing project files, never hardcoded** — the template is meant to
be forked and renamed (see `adapt-template`).

## Step 0 — Discover project context

| Value | Where to read | How to extract |
|---|---|---|
| `kitSlug` | `template-kit/Package.swift` | `name:` at the top (`template-kit`) |
| `kitName` | same | the library product's `name:` (`TemplateKit`) |
| `sharedName` | same | the `binaryTarget` name (`TemplateShared`) |
| `modules` | same | existing `<kitName><Module>` targets (`Core`, `Auth`, `Splash`, `Navigation`) |
| `appDelegate` | Xcode target source group, not inside the kit | the file registering the DI modules |

Derive: `<Feature>` PascalCase (`Profile`), `<feature>` camelCase (`profile`),
`targetName` = `<kitName><Feature>` (`TemplateKitProfile`),
`sources` = `<kitSlug>/Sources/<Feature>/Sources`.

## Step 1 — Ask what the package needs

| Question | Why it changes the output |
|---|---|
| Which KMM ViewModel does it wrap? | `app.di.<feature>ViewModel()` must exist in the XCFramework — verify the name in `TemplateShared.swiftinterface` before writing it (`clean-data-layer`, *When the KMM signature changes*) |
| Which other packages does it import? | target `dependencies:` — `<kitName>Core` is always one |
| Does it own a `NavigationStack`? | if yes it also needs a destination enum and a navigation ViewModel, like `Auth` |

A package with no KMM counterpart is legitimate (a purely presentational one) — it then has no
`Data/` folder at all.

## Step 2 — Create 6 files

### Domain — `clean-domain-layer`

**`{sources}/Domain/States/<Feature>State.swift`** — value type, `Foundation` only, all fields
defaulted, `error` as `String?`:
```swift
import Foundation

struct <Feature>State: Hashable, Sendable {
    var isLoading: Bool = false
    var error: String? = nil
}
```

Add `Domain/States/<Feature>Destination.swift` only when the package pushes onto a
`NavigationStack`; the enum is `Hashable` and carries its navigation arguments.

### Data — `clean-data-layer`

**`{sources}/Data/Mappers/<Feature>State+Dto.swift`** — one direction, KMM types stop here:
```swift
import Foundation
import <sharedName>

extension <Feature>State {
    init(from dto: <sharedName>.<Feature>State) {
        self.init(
            isLoading: dto.isLoading,
            error: dto.error?.message
        )
    }
}
```

No reverse mapper: writes go back as per-field KMM intents.

### Presentation — `clean-presentation-layer`

**`{sources}/Presentation/Internal/View/Models/<Feature>ViewModel.swift`** — the subscription is a
mapping and nothing else:
```swift
import Combine
import SwiftUI

import <sharedName>

@MainActor
final class <Feature>ViewModel: ObservableObject {
    @Published private(set) var state = <Feature>State()

    private let viewModel: <sharedName>.<Feature>ViewModel

    init(app: TemplateApp) {
        viewModel = app.di.<feature>ViewModel()

        viewModel.state.toPublisher()
            .receive(on: RunLoop.main)
            .catch { _ in Empty() }
            .map { <Feature>State(from: $0) }
            .assign(to: &$state)
    }

    func onSubmit() {
        viewModel.onSubmit()
    }
}
```

Each editable field gets a `Binding<T>` property whose setter calls that field's KMM intent
(`onNameUpdate(name:)`) — never a rebuilt state object.

**`{sources}/Presentation/Internal/View/<Feature>View.swift`** — internal, values and bindings only,
no ViewModel and no DI:
```swift
import SwiftUI

struct <Feature>View<Action: View>: View {
    var error: String?
    @ViewBuilder var action: Action

    var body: some View {
        VStack(spacing: 16) {
            if let error {
                Text(error)
                    .foregroundStyle(.red)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            action
        }
        .padding()
    }
}
```

**`{sources}/Presentation/External/View/<Feature>Screen.swift`** — the only public type:
```swift
import SwiftUI

import <kitName>Core

public struct <Feature>Screen: View {
    @InjectedStateObject var viewModel: <Feature>ViewModel

    public init() { }

    public var body: some View {
        <Feature>View(error: viewModel.state.error) {
            Button { viewModel.onSubmit() } label: { Text("Continue") }
                .disabled(viewModel.state.isLoading)
        }
    }
}
```

Navigation arguments arrive as `init` parameters, not from shared state — see `OtpScreen`.

**`{sources}/Presentation/External/Container+register<Feature>Module.swift`** — ViewModels only, no
object scope:
```swift
import Swinject
import Foundation

import <sharedName>

@MainActor
public extension Container {
    func register<Feature>Module() {
        register(<Feature>ViewModel.self) { resolver in
            <Feature>ViewModel(app: resolver.resolve(TemplateApp.self)!)
        }
    }
}
```

## Step 3 — Wire `Package.swift`

Three edits, and the first is the one people forget:

1. add `"<targetName>"` to the library product's `targets:` — without it the app target cannot
   `import` the module, and the error arrives much later than the mistake;
2. add `.<feature>()` to the package's `targets:` array;
3. append the target function in the `extension Target` block:

```swift
static func <feature>() -> Target {
    .target(
        name: "<targetName>",
        dependencies: [
            "<sharedName>",
            "<kitName>Core",

            .product(name: "Swinject", package: "Swinject")
        ],
        path: "./Sources/<Feature>"
    )
}
```

Drop `"<sharedName>"` when the package has no KMM counterpart. A package that renders another
package's screen depends on it too — `Navigation` depends on `Auth` and `Splash` for exactly that.

## Step 4 — Wire DI in the app target

In `AppDelegate`: `import <targetName>`, and `di.register<Feature>Module()` after the modules it
depends on (`registerAppModule()` is always first — it binds `TemplateApp`).

## Step 5 — Verify

```bash
xcodebuild -project <appSlug>.xcodeproj -scheme <appSlug> \
  -destination 'generic/platform=iOS Simulator' build
```

Compiling is the only real check — the layer skills exist because everything else about a package
is a convention the compiler cannot enforce. Report created and modified files.

## Common mistakes

| Mistake | Fix |
|---------|-----|
| Hardcoding `Template` / `TemplateKit` | Read the names out of `Package.swift` first |
| Target added to `targets:` but not to the library product | Both, every time — see Step 3 |
| `.inObjectScope(.container)` on a ViewModel | ViewModels are factories: no scope modifier at all |
| An object that must outlive its screen | Resolve it in a longer-lived view and pass values down, do not widen the DI scope |
| `sink { self?.state = … }` in the subscription | `.map { State(from: $0) }.assign(to: &$state)`; a `sink` body means logic drifted out of Kotlin |
| Reverse mapper `<sharedName>.X(state:)` | Call the per-field KMM intent; `Throwable` cannot be rebuilt from `String` |
| `@Binding`-free editable field | One `Binding<T>` property per editable field on the ViewModel |
| State struct in `Presentation/` | `Domain/States/` — mirroring KMM, where states live in `presentation`, is wrong here |
| ViewModel passed into a `*View` | The Screen reads `state`; the View takes values and closures |
| Guessing a KMM symbol name | Grep the generated `TemplateShared.h` / `.swiftinterface` — they are the source of truth |
