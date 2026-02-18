# Plan: Dependency Update Strategy

## Goal
Update project dependencies to their latest stable versions, prioritizing the Riverpod ecosystem (v3.x/v4.x) and resolving potential conflicts with `analyzer` and `lint` packages. The update will be executed in two distinct phases to ensure stability.

## Success Criteria
- [ ] `flutter_riverpod` updated to `^2.6.1` (Latest Stable) OR `^3.x` (if valid dev/pre-release exists and is intended). *Correction: The user requested 3.2.1, but latest stable is 2.6.1. We will attempt to find the version they saw or stick to latest stable if 3.x is unavailable/broken.*
- [ ] `riverpod`, `riverpod_annotation`, `riverpod_generator` updated to matching versions.
- [ ] `flutter_markdown_plus` remains active.
- [ ] `flutter analyze` passes with 0 errors.
- [ ] App builds and runs.

## Phase 1: Riverpod Ecosystem Update (The "Riverpod Group")
**Packages:** `flutter_riverpod`, `riverpod`, `riverpod_annotation`, `riverpod_generator`, `riverpod_lint`, `custom_lint`.

- [ ] **Task 1: Analyze & Prep**
    - Verify actual available versions on pub.dev (simulated via `flutter pub outdated`).
    - Determine if "3.2.1" was a typo for "2.6.1" or a real pre-release.
- [ ] **Task 2: Update Riverpod Core**
    - Update `pubspec.yaml` for:
        - `flutter_riverpod`
        - `riverpod`
        - `riverpod_annotation`
    - Update `dev_dependencies` for:
        - `riverpod_generator`
- [ ] **Task 3: Resolve Lint Conflicts**
    - Set `riverpod_lint` and `custom_lint` to compatible versions (potentially `any` temporarily to find match, then pin).
    - Run `flutter pub get`.
- [ ] **Task 4: Verify Phase 1**
    - Run `flutter analyze`.
    - Fix any breaking changes in provider definitions (e.g., `StateNotifier` -> `Notifier` migration was already done, but check for others).

## Phase 2: Remaining Packages Update
**Packages:** `go_router`, `intl`, `url_launcher`, `shared_preferences`, `flutter_animate`, etc. (from user's list of 23 outdated).

- [ ] **Task 5: Update Secondary Dependencies**
    - Run `flutter pub outdated` to see candidate versions.
    - Update `pubspec.yaml` with newer versions for safe packages (e.g., `intl`, `url_launcher`).
    - Run `flutter pub get`.
- [ ] **Task 6: Final Verification**
    - Run `flutter analyze`.
    - Manual smoke test (run app).

## Rollback Plan
- If Phase 1 fails: Revert `pubspec.yaml` to current state (Riverpod 3.1.0 / 4.0.0).
- If Phase 2 fails: Revert individual packages that cause issues.
