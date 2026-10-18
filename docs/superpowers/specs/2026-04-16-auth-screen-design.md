# Auth Screen Design

**Date:** 2026-04-16

## Goal

Create a simple login screen in `template-kit/Sources/Auth/` based on the existing `AuthViewModel`.

## File

`template-kit/Sources/Auth/Sources/Presentation/Internal/View/AuthView.swift`

## Layout

Plain `VStack` approach (no Form, no ScrollView):

```
AuthView
└── VStack
    ├── TextField → $state.login
    ├── SecureField → $state.password
    ├── Text(error) — visible only when error != nil, red color
    └── Button "Войти" → onSubmit()
           disabled: state.isLoading
           overlay: ProgressView when state.isLoading
```

## ViewModel Integration

- `@InjectedStateObject var viewModel: AuthViewModel` — resolves the VM through Swinject DI container via environment
- Two-way binding: `$viewModel.state.login` / `$viewModel.state.password`
- Action: `viewModel.onSubmit()`

## Out of Scope

- Navigation on `isAuthenticated` — handled by the parent, not this view
- Styling / design tokens — left neutral for template customization
