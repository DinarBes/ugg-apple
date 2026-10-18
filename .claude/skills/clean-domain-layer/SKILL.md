---
name: clean-domain-layer
description: Use when writing or reviewing code under a package's `Domain` folder — state structs, navigation destinations, shared enums. Triggers on "добавь состояние", "экранный стейт", "domain слой", "destination", or any new file under template-kit/Sources/<Feature>/Sources/Domain.
---

# Domain Layer (Swift)

`Domain` holds the package's plain Swift value types: `States/`. Nothing else.

**The business domain lives in Kotlin.** Entities, UseCases and exceptions are in the KMM repo
(`multiplatform/template-client/client-kit/<feature>/domain`) — see its `clean-domain-layer` skill.
On the Swift side `Domain` is the platform's own vocabulary: the shape a screen renders and the
routes a `NavigationStack` can hold. If you catch yourself writing a rule here — validation, a
retry policy, what "authorized" means — it belongs in a Kotlin UseCase, not in this folder.

## No imports but Foundation

```swift
import Foundation

struct InitiateState: Hashable, Sendable {
    var phone: String = ""
    var isLoading: Bool = false
    var error: String? = nil
}
```

- No `import TemplateShared`, no SwiftUI, no Swinject, no Combine. A `TemplateShared` import here
  is the smell that a DTO leaked past `Data`.
- `Hashable, Sendable`, every field defaulted — the ViewModel must be able to write
  `var state = InitiateState()` before the first KMM emission arrives.
- One struct per screen, mirroring the Kotlin state class field for field, plus UI-only flags the
  Kotlin side has no business knowing (`isFormExpanded`, `isKeyboardVisible`).

## `error` is a `String?`, not a Throwable

Kotlin states carry `error: Throwable?`. Swift flattens it to the message at the mapper boundary
(see `clean-data-layer`) because a `KotlinThrowable` cannot be rebuilt on the Swift side — the
ViewModel keeps the original object when it needs to write back.

Keep `String?` here. `KotlinThrowable` in a `Domain` type means the mapping was skipped.

## Destinations carry navigation arguments

A destination is the Swift half of a Kotlin `Destination` subclass, and it carries the same
arguments — never a shared mutable object between screens:

```swift
enum OtpAuthDestination: Hashable, Sendable {
    case otp(phone: String, sessionId: String)
}
```

`AuthFlow.Otp(phone, sessionId)` in Kotlin → `.otp(phone:sessionId:)` here. `Hashable` is required:
`NavigationPath.append` and `.navigationDestination(for:)` both demand it.

Root-level routing gets its own enum — `RootDestination` in `Navigation` — with a case per KMM
flow plus the one the app starts on:

```swift
enum RootDestination {
    case splash
    case auth
    case launch
}
```

## Shared shapes live in Core

`ContentState<T>` (`.loading | .success(T) | .failure(String)`) is declared once in
`Sources/Core/Sources/Domain/States/`. Use it for a screen whose whole body is one of three
mutually exclusive renderings; do not redeclare a per-feature copy, and do not use it when the
screen shows a spinner *and* content at the same time — that is two fields, not an enum.

## Checklist

- [ ] only `import Foundation`
- [ ] state struct is `Hashable, Sendable` with every field defaulted
- [ ] `error: String?` — no `KotlinThrowable`
- [ ] no business rule, no formatting that a Kotlin entity should already carry
- [ ] destination enum is `Hashable` and carries its navigation arguments as associated values
- [ ] nothing here is `public` unless another package genuinely needs the type
