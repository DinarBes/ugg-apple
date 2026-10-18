---
name: adapt-template
description: Use when the user wants to adapt or initialize the template-apple iOS project for a new application — renaming the Xcode project, SPM package, app class prefix, bundle identifier, KMM dependency path, and feature modules after forking.
---

# Adapting template-apple for a New Project

## Overview

This skill adapts the `template-apple` iOS template to a specific project by replacing all placeholder identifiers with real project values. The template uses `Template` as its class prefix throughout the Xcode project, SPM package (`template-kit`), and KMM XCFramework dependency (`TemplateShared`).

## Step 1 — Collect Parameters

Ask the user for these values (show as a table, wait for all answers before proceeding):

| Parameter | Template value | Description |
|---|---|---|
| `appSlug` | `template-apple` | Kebab-case app repository/folder name (e.g. `fs-apple`) |
| `kitSlug` | `template-kit` | Kebab-case SPM package name (e.g. `fs-kit`) |
| `classPrefix` | `Template` | PascalCase class prefix for all Swift types (e.g. `FS`) |
| `bundleId` | `com.template.apple` | Full Apple bundle identifier (e.g. `com.factorsmile.app`) |
| `kmmClientSlug` | `template-client` | KMM multiplatform repository slug used in the XCFramework path (e.g. `fs-client`) |
| `developmentTeam` | `PWY534XF62` | Apple Developer Team ID (leave blank to keep current) |

Derived automatically (do not ask):
- `modules` = every `TemplateKit<Module>` target in `template-kit/Package.swift` — read them, never
  assume the list (today: `Core`, `Auth`, `Splash`, `Navigation`)
- `kitName` = `classPrefix` + `Kit` (e.g. `FSKit`)
- `sharedName` = `classPrefix` + `Shared` (e.g. `FSShared`)
- `appEntryPoint` = `classPrefix` + `App` (e.g. `FSApp`)
- `xcframeworkPath` = `../../../multiplatform/{kmmClientSlug}/shared/build/XCFrameworks/debug/{sharedName}.xcframework`

## Step 2 — Show Substitution Plan

Before making any changes, present the full substitution plan grouped by file and confirm with the user.

## Step 3 — Execute Changes

Apply changes in this exact order. Use `replace_all: true` on every Edit call.

### 3.1 `template-kit/Package.swift`

- `name: "template-kit"` → `name: "{kitSlug}"`
- `name: "TemplateKit"` (library product) → `name: "{kitName}"`
- `name: "TemplateKit<Module>"` → `name: "{kitName}<Module>"` — **for every module in `modules`**,
  in the library product's `targets:` list, in each `static func` target, and in every
  `dependencies:` array that names another kit target
- `name: "TemplateShared"` (binaryTarget name) → `name: "{sharedName}"`
- `"TemplateShared"` (all dependency references inside targets) → `"{sharedName}"`
- XCFramework path `template-client` segment → `{kmmClientSlug}`
- XCFramework filename `TemplateShared.xcframework` → `{sharedName}.xcframework`
- `static func templateDebugShared()` → `static func {camelCase(kitSlug)}DebugShared()`
- `.templateDebugShared()` call in targets array → `.{camelCase(kitSlug)}DebugShared()`

### 3.2 Swift source files — app target (`template-apple/`)

**`template-apple/TemplateApp.swift`**
- `TemplateApp` → `{appEntryPoint}`

**`template-apple/AppDelegate.swift`**
- `import TemplateKit<Module>` → `import {kitName}<Module>`, one per module it imports

**`template-apple/ContentView.swift`**
- `import TemplateKitNavigation` → `import {kitName}Navigation`

### 3.3 Swift source files — `template-kit/Sources/`

For every `.swift` file under `template-kit/Sources/`:
- `import TemplateKit<Module>` → `import {kitName}<Module>`
- `TemplateShared` → `{sharedName}` — the import **and** every qualified reference
  (`TemplateShared.InitiateState`, `TemplateShared.SplashViewModel`, …)

**Do not touch `TemplateApp` and `TemplateCore` here.** Those are Kotlin class names exported by the
XCFramework, and `adapt-template-client-template` on the KMM side renames packages and the framework
name only — the classes keep their names. A blanket `Template` → `{classPrefix}` rewrite over
`Sources/` breaks the build in `Container+registerAppModule.swift` and in every
`init(app: TemplateApp)`. The only `TemplateApp` that *is* renamed is the `@main struct` in the app
target (3.2).

Use Grep to find all affected files first:
```bash
grep -rl "TemplateKit\|TemplateShared" \
  template-kit/Sources --include="*.swift"
```

Renaming the module directories themselves (`Sources/Auth/` and friends) is **not** part of this
skill — the folder names are module names, not template identifiers, and `Package.swift` points at
them by `path:`.

Then apply the substitutions to each file.

### 3.4 `template-apple.xcodeproj/project.pbxproj`

This file contains hardcoded references to both the Xcode target name and the SPM package product. Apply these substitutions:

- `template-apple.app` → `{appSlug}.app`
- `path = "template-kit"` → `path = "{kitSlug}"`
- `name = "template-apple"` (target name occurrences) → `name = "{appSlug}"`
- `productName = "template-apple"` → `productName = "{appSlug}"`
- `/* template-apple */` (comment references) → `/* {appSlug} */`
- `/* TemplateKit */` (comment references) → `/* {kitName} */`
- `name: "TemplateKit"` (package product dependency) → `name: "{kitName}"`
- `PRODUCT_BUNDLE_IDENTIFIER = com.template.apple` → `PRODUCT_BUNDLE_IDENTIFIER = {bundleId}`
- If `developmentTeam` was provided: `DEVELOPMENT_TEAM = PWY534XF62` → `DEVELOPMENT_TEAM = {developmentTeam}`

> **Warning:** `project.pbxproj` is a binary-ish text format. Use `replace_all: true` so all Debug/Release configurations are updated. After editing, open the project in Xcode once to let it re-index.

### 3.5 Rename files and directories

Rename AFTER editing file contents, so edits target the original paths.

| Old path | New path |
|---|---|
| `template-apple/TemplateApp.swift` | `template-apple/{appEntryPoint}.swift` |
| `template-apple/` (source group dir) | `{appSlug}/` |
| `template-kit/` (SPM package dir) | `{kitSlug}/` |
| `template-apple.xcodeproj/` | `{appSlug}.xcodeproj/` |

Run via Bash:
```bash
# 1. Rename app entry point Swift file
mv template-apple/TemplateApp.swift "template-apple/{appEntryPoint}.swift"

# 2. Rename source group directory
mv template-apple "{appSlug}"

# 3. Rename SPM package directory
mv template-kit "{kitSlug}"

# 4. Rename Xcode project
mv template-apple.xcodeproj "{appSlug}.xcodeproj"
```

After renaming, update `project.pbxproj` path references that still contain the old directory name (the rename in step 3.4 covered names, but the `path =` for the synchronized root group now reflects the new directory):
- `path = "template-apple"` (PBXFileSystemSynchronizedRootGroup) → `path = "{appSlug}"`

### 3.6 `template-apple.xcodeproj/project.xcworkspace/contents.xcworkspacedata`

- Any occurrence of `template-apple` → `{appSlug}`

## Step 4 — Verify

After all changes:

1. Grep for any remaining occurrences of old identifiers — `TemplateApp` and `TemplateCore` are
   expected to survive inside `Sources/`, see 3.3:
```bash
grep -r "template-apple\|template-kit\|TemplateKit\|TemplateShared\|com\.template" \
  --include="*.swift" --include="*.kts" --include="*.xcworkspacedata" \
  --exclude-dir=build --exclude-dir=".build" --exclude-dir=".git"
```

2. Also check `project.pbxproj`:
```bash
grep "template-apple\|template-kit\|TemplateKit\|TemplateShared\|com\.template" \
  "{appSlug}.xcodeproj/project.pbxproj"
```

3. If any remain, fix them before finishing.

4. Build — the only check that proves the rename is complete:
```bash
xcodebuild -project {appSlug}.xcodeproj -scheme {appSlug} \
  -destination 'generic/platform=iOS Simulator' build
```

5. Report a summary: files changed, files renamed, directories renamed, and any manual steps required (e.g. re-selecting the scheme in Xcode after project rename).

## Common Mistakes

| Mistake | Fix |
|---|---|
| Renaming files/dirs before editing contents | Always edit first, rename after — paths change under you |
| Forgetting `project.pbxproj` comment references | Xcode embeds `/* TargetName */` inline — update those too |
| Missing `contents.xcworkspacedata` | Small file but it stores the project path — Xcode won't open the workspace otherwise |
| Skipping the SPM binaryTarget path | `TemplateShared.xcframework` path contains both the KMM repo slug and the framework name — both must change |
| Renaming `TemplateApp` / `TemplateCore` in `template-kit/Sources/` | Kotlin class names from the XCFramework — the KMM template keeps them; only the app target's `@main struct` is renamed |
| Hardcoding the module list | Read the `TemplateKit*` targets out of `Package.swift`; a fork may have added or dropped modules |
| Using lowercase `classPrefix` | Must be PascalCase to match Swift naming conventions |
| Forgetting `replace_all: true` | pbxproj has Debug and Release blocks — a single replacement misses the second |
| Not verifying after renaming | Run the grep verification step; binary `.xcodeproj` sometimes holds extra name references |
