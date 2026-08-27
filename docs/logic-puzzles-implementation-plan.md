# Logic Puzzle Solver in Lean 4

This plan outlines the design and implementation for porting the
"Breakfast at Tiffany's" logic puzzle solver from Haskell into
idiomatic Lean 4. Work is split into two commits on the existing
`logic-puzzle` branch.

## Commit Strategy

> [!IMPORTANT]
> **Commit 1 — Toolchain Upgrade**: Bump lean-toolchain, lakefile
> dependencies, and docbuild toolchain to v4.32.0. Verify `make
> build lint test doc` all pass before proceeding.
>
> **Commit 2 — Puzzle Implementation**: Add the `LogicPuzzles`
> module hierarchy, tests, Makefile target, and demo integration.

## Pre-flight: Dependency Tag Verification

Before touching any files, verify that these tags exist:

- `leanprover-community/batteries` → `v4.32.0`
- `leanprover-community/plausible` → `v4.32.0`
- `leanprover/doc-gen4` → `v4.32.0`

If any tag is missing, halt and find the correct revision.

---

## Commit 1 — Toolchain Upgrade (v4.31.0 → v4.32.0)

### [MODIFY] [lean-toolchain](file:///home/frank/dev/lean4/learning/lean-toolchain)

- Bump from `leanprover/lean4:v4.31.0` to
  `leanprover/lean4:v4.32.0`.

### [MODIFY] [docbuild/lean-toolchain](file:///home/frank/dev/lean4/learning/docbuild/lean-toolchain)

- Bump to `leanprover/lean4:v4.32.0`.

### [MODIFY] [lakefile.toml](file:///home/frank/dev/lean4/learning/lakefile.toml)

- Update `rev` for `doc-gen4`, `batteries`, and `plausible` to
  `v4.32.0`.

### Regenerate manifests

- Run `lake update` in project root and in `docbuild/`.
- Verify `make build lint test doc` all pass.

## Commit 2 — Puzzle Implementation

### Module Hierarchy

#### [NEW] [Perm.lean](file:///home/frank/dev/lean4/learning/Learning/LogicPuzzles/Perm.lean)

Reusable combinatorial helpers in
`namespace Learning.LogicPuzzles.Perm`:

| Function | Signature | Purpose |
| ---------- | ----------- | --------- |
| `insertions` | `α → List α → List (List α)` | All ways to insert an element |
| `permutations` | `List α → List (List α)` | Total, structurally recursive perms |
| `zipWith4` | `(α → β → γ → δ → ε) → List α → …` | Zip four lists with a function |

All functions must be **total** (no `partial`, no `sorry`).
Docstrings wrapped at 80 columns.

#### [NEW] [Breakfast.lean](file:///home/frank/dev/lean4/learning/Learning/LogicPuzzles/Breakfast.lean)

Port the Haskell puzzle into
`namespace Learning.LogicPuzzles.Breakfast`.

**Domain types** — plain inductives:

```lean
inductive Name | Jenny | Jackie | Samantha | Judy
  deriving BEq, Repr, Inhabited

inductive Drink | Orange | Apple | Tea | Milk
  deriving BEq, Repr, Inhabited

inductive Meal | Toast | Omelet | Pancakes | Cereal
  deriving BEq, Repr, Inhabited

inductive ToGo | Lemonade | Water | Coffee | Latte
  deriving BEq, Repr, Inhabited
```

Manual `ToString` instances for display formatting.

**Assignment type** — flat product tuple:

```lean
abbrev Assignment := Name × Drink × Meal × ToGo
```

**Solution type**:

```lean
-- Each inner list is one complete 4-person assignment.
-- Outer list holds all valid solutions (expect exactly 1).
def answers : List (List Assignment) := …
```

**Search strategy** — generate-and-filter:

- Names are **fixed** in order
  `[Jenny, Jackie, Samantha, Judy]`.
- Permute only `drinks`, `meals`, `togos`
  (4! × 4! × 4! = 13,824 candidates).
- Combine via `zipWith4`.
- Filter with a single `isValid` predicate.

**Constraint checking**:

- `isValid` delegates to 6 named helpers: `clue1` … `clue6`.
- Each `clueN` function has a **docstring quoting the original
  puzzle clue text**.
- Uses `List.find?` for clues that reference "the person who
  ordered X" (clues 2, 3, 4, 5).

**Verification** — lightweight:

- `#eval answers.length` sanity check (expect `1`).
- No kernel proof / `native_decide` theorem.
- Correctness validated by unit tests.

**Module docstring** includes reference to:
<https://www.ahapuzzles.com/logic/logic-puzzles/breakfast-at-tiffanys/>

**Display** — plain aligned text table matching existing demo
style (simple `IO.println` with `s!"…"` interpolation).

#### [NEW] [LogicPuzzles.lean](file:///home/frank/dev/lean4/learning/Learning/LogicPuzzles.lean)

Library export module re-exporting:

- `Learning.LogicPuzzles.Perm`
- `Learning.LogicPuzzles.Breakfast`

#### [MODIFY] [All.lean](file:///home/frank/dev/lean4/learning/Learning/All.lean)

Add `import Learning.LogicPuzzles`.

#### [MODIFY] [Learning.lean](file:///home/frank/dev/lean4/learning/Learning.lean)

- Import `Learning.LogicPuzzles.Breakfast`.
- Add `demoLogicPuzzle : IO Unit` showcasing the solution table.
- Call `demoLogicPuzzle` from `main`.

### Makefile

#### [MODIFY] [Makefile](file:///home/frank/dev/lean4/learning/Makefile)

Add target:

```makefile
puzzle: ## Run the logic puzzle solver
        @$(LAKE) exe learning
```

Add `puzzle` to the `.PHONY` list.

### Test Suite

#### [NEW] [Test/LogicPuzzles.lean](file:///home/frank/dev/lean4/learning/Test/LogicPuzzles.lean)

Tests using the existing `Test.Util` harness:

| Test | Assertion |
| ------ | ----------- |
| Perm count | `(permutations [1,2,3]).length == 6` |
| Perm completeness | All elements present in each permutation |
| `zipWith4` | Basic behaviour on small lists |
| Unique solution | `answers.length == 1` |
| Jenny's assignment | Tea, Toast, Latte |
| Jackie's assignment | Orange, Pancakes, Coffee |
| Samantha's assignment | Milk, Cereal, Water |
| Judy's assignment | Apple, Omelet, Lemonade |

#### [MODIFY] [Test.lean](file:///home/frank/dev/lean4/learning/Test.lean)

- Import `Test.LogicPuzzles`.
- Add `Test.LogicPuzzles.runTests st` call.

---

## Verification Plan

### Automated Tests

1. `make build` — Lean 4.32.0 compilation succeeds.
2. `make lint` — Batteries linters pass with zero warnings.
3. `make test` — All existing + new logic puzzle tests pass.
4. `make doc` — `doc-gen4` documentation generation succeeds.

### Manual Verification

1. `make puzzle` — inspect the solution table output:

| Name     | Drink  | Meal     | To Go    |
|----------|--------|----------|----------|
| Jenny    | Tea    | Toast    | Latte    |
| Jackie   | Orange | Pancakes | Coffee   |
| Samantha | Milk   | Cereal   | Water    |
| Judy     | Apple  | Omelet   | Lemonade |

## Walk-through

The implementation has been completed successfully following this plan.

- **Toolchain Upgrade**: `lean-toolchain` and dependencies were updated to `v4.32.0`. The `docbuild` environment was also updated successfully.
- **Permutation Helpers**: `Learning/LogicPuzzles/Perm.lean` implements total and structurally recursive `insertions`, `permutations`, and `zipWith4`.
- **Puzzle Logic**: `Learning/LogicPuzzles/Breakfast.lean` defines the puzzle domains (`Name`, `Drink`, `Meal`, `ToGo`) as plain inductive types. The state space of permutations is generated and checked cleanly with the `clueN` functions, accurately isolating the single valid answer out of 13,824 possibilities.
- **Tests**: `Test/LogicPuzzles.lean` covers permutation length and completeness, `zipWith4` functionality, and strictly asserts the one valid state of the puzzle constraint system.
- **Execution**: The `make puzzle` command successfully builds and displays the ASCII table. All lints, tests, and documentation build correctly.

> [!TIP]
> If you run into an `incompatible header` error when running `make doc`, it is because of stale `.olean` cache files left over from the previous Lean version. Simply run `make clean` first to clear the cache, and `make doc` will compile perfectly.
