# Changelog

All notable changes to the `learning` Lean project are documented in this file.

## [Unreleased]

### Added

- **Library:** Added `Learning/All.lean` as a convenience re-export
  module for the full `Learning` library (`Basic`, `HelloWorld`,
  `Structure`).
- **Documentation:**
  - Elan installation instructions for Linux and macOS.
  - Development section outlining common Makefile targets
    (`build`, `test`, `lint`, and `doc`).
  - Documented the repository's project structure in `README.md`,
    including the new `Learning/All.lean` module.
  - Added links for the Lean Language Guide and licence references.
  - Filled in the missing `lean --version` command in the README.
  - Updated `README.md` to reflect the updated executable showcase
    behaviour and list the correct test files in the workspace.

### Changed

- **Executable:** Updated the `learning` executable entrypoint to run
  a showcase demonstrating the `Learning.Basic`, `Learning.HelloWorld`,
  and `Learning.Structure` modules. The hello world greeting now
  accepts an optional name argument, defaulting to `"World"` if
  omitted.
- **Project Structure:** Renamed `Main.lean` to `Learning.lean` as the
  entry point for the `learning` executable, following the idiomatic
  Lean 4 convention of naming the executable root after the package.
  The previous `Learning.lean` library root (import re-exports) was
  moved to `Learning/All.lean`.
- **Lake Configuration (`lakefile.toml`):**
  - Set `globs = ["Learning.+"]` on the `Learning` library so Lake
    auto-discovers all submodules under `Learning/` without requiring a
    top-level library root file.
  - Updated the `learning` executable `root` from `Main` to `Learning`.
  - Added `"Learning"` to `defaultTargets`.
  - Removed explicit `lintDriverArgs`; `lake lint` now auto-detects
    default targets, which restricts linting to project modules only
    and avoids picking up identically-named modules from dependencies
    (e.g. `MD4Lean/Main.lean`).
- **Tooling:** Upgraded the Lean toolchain to `v4.31.0-rc2` and updated
  dependencies (including community `batteries` and `doc-gen4`) for both
  the main package and the documentation build configuration.

### Fixed

- **Linting:**
  - Restricted `lake lint` scope to project-owned modules by configuring
    `lintDriverArgs` in `lakefile.toml`, preventing lint errors from
    surfacing in third-party dependency packages (e.g. `MD4Lean`).
  - Added missing doc strings to `Learning.Basic.lisaAge`,
    `Learning.Structure.Point.x`, `Learning.Structure.Point.y`, and
    `Learning.Structure.p2`.
  - Replaced the auto-derived `Repr Point` instance (which triggered an
    `unusedArguments` warning on the `prec` parameter) with a manual
    `instance : Repr Point` that binds `_prec`.
  - Fixed typographical errors in doc strings for `Learning.Basic.tonyAge`
    and `Learning.Structure.p1`.
  - Converted the comment in `Learning/All.lean` to a module docstring.
  - Added missing doc strings to `Test.Basic.runTests`,
    `Test.HelloWorld.runTests`, and `Test.main`.
- **Build System:**
  - Configured the `Makefile` to dynamically resolve the Lean
    installation prefix and set `LD_LIBRARY_PATH` before invoking
    `lake`, preventing runtime link errors.
  - Silenced the output of Makefile commands by prefixing recipe lines
    with `@`.
  - Fixed syntax errors in the `Makefile` `doc` and `update` targets
    by removing invalid `@` prefixes from within multi-line shell
    commands.
  - Standardised directory changing in the Makefile using the `CD`
    variable.
  - Updated Makefile to view locally generated documentation.
- **README:**
  - Added `Test/Util.lean` to the project structure documentation.
  - Corrected `lake lint -- --update` to `lake lint --update`
    (the double-dash was incorrect syntax).

## [0.1.0] - 2026-06-03

### Added

- **License:** Added the GNU GPL 3 license.
- **CI/CD Pipeline:**
  - Integrated GitHub Actions workflow for automatic documentation build and
    deployment to GitHub Pages.
  - Integrated automated test suite execution into the CI workflow.
  - Integrated the `batteries` linter driver into the CI/CD pipeline.
- **Build System & Tooling:**
  - Added a `Makefile` supporting targets for `build`, `test`, `lint`, `doc`,
    `update`, `clean`, and `cleanall` to automate developer tasks.
  - Declared `LAKE`, `CD`, and `RM` variables in the `Makefile` for platform
    portability.
  - Upgraded Lean toolchain to `v4.31.0-rc1`.
- **Testing Suite:**
  - Implemented a custom test suite runner (`Test.lean`) and utilities
    (`Test/Util.lean`) to run assertions automatically.
  - Prefixed all test-related console output with `[TEST]` for cleaner logging
    and parsing.
- **Documentation:**
  - Added design documentation for the build system (`docs/makefile.md`).
  - Added deployment documentation for GitHub Pages (`docs/pages.md`).
  - Added default linter suppression file (`scripts/nolints.json`).
  - Expanded `README.md` to include execution examples and linter configuration
    details.

### Changed

- **Main Entrypoint (`Main.lean`):** Updated the entrypoint to support basic CLI
  arguments.
- **Makefile Configuration:** Reorganized targets and aligned the default goal
  to run `build test lint`.
- **Makefile Documentation (`docs/makefile.md`):** Aligned default goals to run
  `build test lint` (omitting `update`) and corrected grammatical errors.
- **CI Pages Documentation (`docs/pages.md`):** Corrected grammatical typos
  regarding GitHub Pages publishing.
- **CI Workflow
  ([.github/workflows/lean_action_ci.yml](.github/workflows/lean_action_ci.yml)):**
  Split the CI into separate `build` (compile, lint, test), `docs` (build
  documentation and upload pages artifact on `main`), and `pages` (deploy-only)
  jobs. This prevents a second compile on the Pages runner and reduces PR
  latency.

### Fixed

- **Doc Generation Configuration (`docbuild/lakefile.toml`):** Configured
  `[leanOptions]` with `maxHeartbeats = 0` to prevent heartbeat timeout warnings
  during documentation compilation.
- **Lake Configuration (`lakefile.toml`):** Restored the `[[lean_lib]]`
  definition for `Test` to fix build errors where the `Test` module prefix was
  unknown to the compiler.
- **Gitignore (`.gitignore`):** Cleaned up duplicate entries for `/.lake` and
  `docbuild/.lake`, and reordered entries for better readability.
- **Code Standards (`Learning/Basic.lean`, `Test/Basic.lean`):** Renamed the
  `HitchHiker` function to `hitchHiker` to adhere to standard Lean 4 camelCase
  conventions.
- **Code Formatting (`Learning/HelloWorld.lean`):** Replaced hard tabs with
  spaces and corrected pattern-matching indentation.
