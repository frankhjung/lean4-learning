# Logic Puzzle Solver in Lean 4

This plan outlines the design and implementation for porting the "Breakfast
at Tiffany's" logic puzzle solver from Haskell into idiomatic Lean 4,
organising the puzzle code within a new module hierarchy, updating the
project toolchain and dependencies to Lean `v4.32.0`, and expanding Lake,
Makefile, and test suites.

## Background & Objectives

The target logic puzzle is defined in the Haskell project
`LogicPuzzles.Breakfast`. It models four friends (Jenny, Jackie, Samantha,
and Judy) meeting for breakfast at a downtown NYC hotel, ordering a meal,
a breakfast drink, and a takeaway drink. Six logical constraints prune the
search space of $4! \times 4! \times 4! = 13,824$ permutations down to a
single unique solution.

Our objective is to implement a purely functional, total, and verified
solution in Lean 4 conforming to the `lean-programmer` skill guidelines:
- Work strictly within git branch `logic-puzzle`.
- Create a reusable `Learning/LogicPuzzles/` module hierarchy with total
  combinatorial helpers and the concrete puzzle solution.
- Upgrade `lean-toolchain` and `lakefile.toml` dependencies from `v4.31.0`
  to `v4.32.0`.
- Update `Learning.lean`, `Makefile`, and test runners.

## User Review Required

> [!IMPORTANT]
> **Toolchain Upgrade to Lean 4.32.0**: We plan to bump `lean-toolchain` from
> `leanprover/lean4:v4.31.0` to `leanprover/lean4:v4.32.0` (which is already
> installed on your machine) alongside corresponding `v4.32.0` revisions for
> `batteries`, `doc-gen4`, and `plausible`.

> [!NOTE]
> **Combinatorics Approach**: Rather than pulling in large transitive Mathlib
> dependencies, we implement total, structurally recursive `insertions`,
> `permutations`, and `zipWith4` functions in `Learning/LogicPuzzles/Perm.lean`.
> These functions evaluate instantaneously during builds and kernel reduction.

## Proposed Changes

### Toolchain & Project Configuration

#### [MODIFY] [lean-toolchain][link-lean-toolchain]
- Bump version string from `leanprover/lean4:v4.31.0` to
  `leanprover/lean4:v4.32.0`.

#### [MODIFY] [docbuild/lean-toolchain][link-docbuild-toolchain]
- Bump version string to `leanprover/lean4:v4.32.0` to maintain consistency.

#### [MODIFY] [lakefile.toml][link-lakefile-toml]
- Update git revisions of `doc-gen4`, `batteries`, and `plausible` to
  `v4.32.0`.
- Regenerate `lake-manifest.json` using `lake update`.

#### [MODIFY] [Makefile][link-makefile]
- Add target `puzzle` to run the puzzle solver executable demonstration.
- Ensure all existing targets (`build`, `lint`, `test`, `doc`) function cleanly
  with `v4.32.0`.

---

### Logic Puzzle Implementation

#### [NEW] [Perm.lean][link-perm-lean]
- Define total, structurally recursive permutation helpers:
  - `insertions : α → List α → List (List α)`
  - `permutations : List α → List (List α)`
  - `zipWith4 : (α → β → γ → δ → ε) →`
    `List α → List β → List γ → List δ → List ε`
- Document with docstrings wrapped at 80 columns.

#### [NEW] [Breakfast.lean][link-breakfast-lean]
- Port the Haskell puzzle into `namespace Learning.LogicPuzzles.Breakfast`:
  - Inductive types: `Name`, `Drink`, `Meal`, `ToGo` with `DecidableEq`,
    `Repr`, and `ToString` instances.
  - Record structure `Assignment` (`name`, `drink`, `meal`, `togo`).
  - Clue checking functions corresponding to the 6 clues from the problem.
  - Search function `answers : List Solution` generating valid assignments.
  - Verified theorem / decidable proposition proving uniqueness:
    `theorem unique_solution : answers.length = 1`.
  - Display formatter: Markdown / ASCII table formatting matching the
    Haskell solution table.

#### [NEW] [LogicPuzzles.lean][link-logic-puzzles-lean]
- Library export module re-exporting `Learning.LogicPuzzles.Perm` and
  `Learning.LogicPuzzles.Breakfast`.

#### [MODIFY] [All.lean][link-all-lean]
- Re-export `Learning.LogicPuzzles`.

#### [MODIFY] [Learning.lean][link-learning-lean]
- Import `Learning.LogicPuzzles.Breakfast`.
- Add `demoLogicPuzzle : IO Unit` showcasing the solution table.
- Call `demoLogicPuzzle` from `main`.

---

### Test Suite Integration

#### [NEW] [Test/LogicPuzzles.lean][link-test-logic-puzzles-lean]
- Add unit tests verifying:
  - Permutations count ($n!$).
  - `zipWith4` behaviour.
  - Puzzle solver yielding exactly 1 unique solution.
  - Verification that Jenny, Jackie, Samantha, and Judy have their correct
    meal and beverage assignments.

#### [MODIFY] [Test.lean][link-test-lean]
- Import `Test.LogicPuzzles` and invoke `Test.LogicPuzzles.runTests st`.

## Verification Plan

### Automated Tests
1. Run `make build` to verify Lean 4.32.0 compilation of the library and
   executables.
2. Run `make lint` to ensure Batteries linters pass with zero warnings.
3. Run `make test` to verify all 38 existing tests and new logic puzzle tests
   pass.
4. Run `make doc` to verify `doc-gen4` documentation generation succeeds.

### Manual Verification
1. Run `make puzzle` or `lake exe learning` to inspect the pretty-printed
   solution table and confirm it matches the Haskell output:
   - Jenny: Tea, French Toast, Latte
   - Jackie: Orange Juice, Potato Pancakes, Coffee
   - Samantha: Milk, Cereal, Bottle of Water
   - Judy: Apple Juice, Omelette, Lemonade

[link-lean-toolchain]:
  file:///home/frank/dev/lean4/learning/lean-toolchain
[link-docbuild-toolchain]:
  file:///home/frank/dev/lean4/learning/docbuild/lean-toolchain
[link-lakefile-toml]:
  file:///home/frank/dev/lean4/learning/lakefile.toml
[link-makefile]:
  file:///home/frank/dev/lean4/learning/Makefile
[link-perm-lean]:
  file:///home/frank/dev/lean4/learning/Learning/LogicPuzzles/Perm.lean
[link-breakfast-lean]:
  file:///home/frank/dev/lean4/learning/Learning/LogicPuzzles/Breakfast.lean
[link-logic-puzzles-lean]:
  file:///home/frank/dev/lean4/learning/Learning/LogicPuzzles.lean
[link-all-lean]:
  file:///home/frank/dev/lean4/learning/Learning/All.lean
[link-learning-lean]:
  file:///home/frank/dev/lean4/learning/Learning.lean
[link-test-logic-puzzles-lean]:
  file:///home/frank/dev/lean4/learning/Test/LogicPuzzles.lean
[link-test-lean]:
  file:///home/frank/dev/lean4/learning/Test.lean
