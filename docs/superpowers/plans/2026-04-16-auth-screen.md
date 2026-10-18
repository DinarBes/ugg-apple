# Auth Screen Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create a minimal SwiftUI login screen inside the Auth module that binds to `AuthViewModel`.

**Architecture:** Single `AuthView` file in `Presentation/Internal/View/`. Uses `@InjectedStateObject` (from `TemplateKitCore`) to resolve `AuthViewModel` from the Swinject DI container. Navigation on `isAuthenticated` is left to the parent.

**Tech Stack:** SwiftUI, Combine, Swinject (via `InjectedStateObject`)

---

### Task 1: Add TemplateKitCore dependency to TemplateKitAuth

**Files:**
- Modify: `template-kit/Package.swift` — добавить `"TemplateKitCore"` в зависимости таргета `auth()`

- [ ] **Step 1: Обновить Package.swift**

Найти функцию `auth()` и добавить `"TemplateKitCore"` в dependencies:

```swift
static func auth() -> Target {
    .target(
        name: "TemplateKitAuth",
        dependencies: [
            "TemplateKitCore",
            "TemplateShared",

            .product(name: "Swinject", package: "Swinject")
        ],
        path: "./Sources/Auth"
    )
}
```

- [ ] **Step 2: Убедиться что проект собирается**

В Xcode: `Cmd+B`. Ожидаем: Build Succeeded без ошибок.

- [ ] **Step 3: Commit**

```bash
git add template-kit/Package.swift
git commit -m "chore(auth): add TemplateKitCore dependency"
```

---

### Task 2: Create AuthView

**Files:**
- Create: `template-kit/Sources/Auth/Sources/Presentation/Internal/View/AuthView.swift`

- [ ] **Step 1: Создать файл**

```swift
//
//  AuthView.swift
//  template-kit
//

import SwiftUI

import TemplateKitCore

struct AuthView: View {
    @InjectedStateObject var viewModel: AuthViewModel

    var body: some View {
        VStack(spacing: 16) {
            TextField("Логин", text: $viewModel.state.login)
                .textContentType(.username)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)

            SecureField("Пароль", text: $viewModel.state.password)
                .textContentType(.password)

            if let error = viewModel.state.error {
                Text(error)
                    .foregroundStyle(.red)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Button {
                viewModel.onSubmit()
            } label: {
                Group {
                    if viewModel.state.isLoading {
                        ProgressView()
                    } else {
                        Text("Войти")
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .disabled(viewModel.state.isLoading)
        }
        .padding()
    }
}
```

- [ ] **Step 2: Убедиться что проект собирается**

В Xcode: `Cmd+B`. Ожидаем: Build Succeeded без ошибок.

- [ ] **Step 3: Commit**

```bash
git add template-kit/Sources/Auth/Sources/Presentation/Internal/View/AuthView.swift
git commit -m "feat(auth): add AuthView"
```
