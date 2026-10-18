---
name: clean-data-layer
description: Use when mapping a KMM state or destination into a Swift value type in a package's `Data` folder. Triggers on "маппер", "data слой", "+Dto", `onEnum(of:)`, or any file under template-kit/Sources/<Feature>/Sources/Data.
---

# Data Layer (Swift)

`Data` contains exactly one kind of thing: `mappers/`. No repositories, no services, no networking.

**There is no Swift data layer in the usual sense.** HTTP, the keystore, caching and retries all
live in the KMM repo (`infrastructure/api/*`, `infrastructure/keystore/*`) and are consumed through
`TemplateShared`. If you are about to write `URLSession`, `Keychain`, or a `Repository` class in
this folder, stop: the source belongs behind a Kotlin service, bound once in
`client-kit/core/data` — see the KMM `clean-data-layer` skill.

What `Data` does here is the boundary job: **`TemplateShared` types stop at this folder** and
continue as `Domain` value types.

## Mappers

**File name: `<DomainType>+Dto.swift`**, in `Data/Mappers/`. An `init(from dto:)` on the Swift type:

```swift
import Foundation
import TemplateShared

extension InitiateState {
    init(from dto: TemplateShared.InitiateState) {
        self.init(
            phone: dto.phone,
            isLoading: dto.isLoading,
            error: dto.error?.message
        )
    }
}
```

- One file per Swift type, all Kotlin sources for that type in it.
- Pure: no DI, no side effects, no `async`. A mapper that needs a dependency is not a mapper.
- Qualify the Kotlin side as `TemplateShared.InitiateState` — the two types share a name on purpose,
  and the qualifier is what keeps the file readable.
- `Throwable` flattens to `dto.error?.message` here and nowhere else.

## One direction only

There is no `TemplateShared.X(state:)` reverse mapper, and no need for one. Swift never hands Kotlin
a state object — it calls a **per-field intent** on the KMM ViewModel:

```swift
set: { self.viewModel.onPhoneUpdate(phone: $0) }
```

Kotlin owns the copy (`state.update { it.copy(phone = phone) }`), so the fields Swift flattened on
the way in never have to be reconstructed. That matters concretely: `error: Throwable?` arrives here
as `dto.error?.message`, and a `String` cannot become a `Throwable` again. A reverse mapper would
pass `nil` and silently erase the error the Kotlin ViewModel had just set.

When a Kotlin ViewModel predates the convention and exposes only `onStateChange(new:)`, the write
costs a read-back — `viewModel.state.value.doCopy(phone: newValue, isLoading: …, error: …)`, every
untouched field passed straight through. It works, but treat it as a missing Kotlin method, not as
the pattern: add `onPhoneUpdate` on that side and the Swift setter collapses to one line.

## Sealed Kotlin types map with `onEnum(of:)`

SKIE exports a Kotlin `sealed class` as a Swift enum. Use it and let the compiler prove the mapping
is exhaustive — an `as?` chain with a `default` silently swallows the case someone adds next month:

```swift
extension RootDestination {
    init(from dto: TemplateShared.SplashFlow) {
        self = switch onEnum(of: dto) {
            case .auth:
                .auth
            case .launch:
                .launch
        }
    }
}
```

`as?` casting is still right in one place: picking *your* feature's routes out of the stream of all
navigation events, where foreign routes must be ignored rather than handled
(`guard let flow = event.route as? SplashFlow else { return }`).

## When the KMM signature changes

`TemplateShared.xcframework` is a binary target built from
`../../../multiplatform/template-client`. The generated headers are the source of truth for what a
type actually looks like on this side:

```
shared/build/XCFrameworks/debug/TemplateShared.xcframework/ios-arm64_x86_64-simulator/
  TemplateShared.framework/Headers/TemplateShared.h        # ObjC signatures, doCopy names
  TemplateShared.framework/Headers/TemplateShared.apinotes # SKIE flow typing (SkieKotlinStateFlow<T>)
  TemplateShared.framework/Modules/…/*.swiftinterface      # SKIE enums, suspend fns, DI helpers
```

Grep those before guessing a name. A rebuilt framework with a renamed field breaks exactly one
file per type — that is the point of keeping the mapping in `Data`.

## Checklist

- [ ] file named `<DomainType>+Dto.swift` under `Data/Mappers/`
- [ ] `import TemplateShared` appears in `Data` and never in `Domain`
- [ ] mapper is a pure `init(from dto:)`, no DI, no `async`
- [ ] Kotlin side spelled `TemplateShared.<Type>` when the names collide
- [ ] sealed Kotlin types switched through `onEnum(of:)` with no `default`
- [ ] no reverse mapper — write-back is a per-field KMM intent, not a rebuilt state object
- [ ] no repository, service, `URLSession` or keychain call in this folder
