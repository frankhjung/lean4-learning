/-! Basic examples: conditionals, numeric functions, and simple types.

This file contains small example definitions used in the `learning` package's
tests and demos. The examples illustrate conditional expressions, basic
arithmetic, type aliases/abbreviations, and simple boolean predicates.
-/

/-- Return a string that appends either `42` or `0` to `name` depending on
`value`. This demonstrates a conditional expression and `toString`
conversion. -/
def hitchHiker (name : String) (value : Int) : String :=
  String.append name (toString (if value > 2 then 42 else 0))

/-- Increment `n` by one. Simple example of a numeric function on `Nat`. -/
def add1 (n : Nat) : Nat := n + 1

/-- Return the larger of `n` and `k`. -/
def maximum (n : Nat) (k : Nat) : Nat := if n < k then k else n

/-- `Name` is a type alias for `String`, used in examples. -/
def Name : Type := String

/-- An example `Name` value used in demonstrations. -/
def name : Name := "Alice"

/-- `Age` is a type abbreviation for `Nat` used to make intent clearer. -/
abbrev Age : Type := Nat

/-- Return `true` when `age` represents an adult (>= 18). -/
def isAdult (age : Age) : Bool := age >= 18

/-- Example age used in tests/demonstrations. -/
def tonyAge : Age := 25
/-- Example age used in tests/demonstrations. -/
def lisaAge : Age := 15

/-! Check adult status: -/
example : isAdult tonyAge = true := rfl
example : isAdult lisaAge = false := rfl

/-- Safe head: equivalent to `List.head`, but requires a proof of
non-emptiness. -/
def safeHead {α : Type} (xs : { l : List α // l ≠ []}) : α :=
  match xs with
  | ⟨[], h⟩ => False.elim (h rfl)
  | ⟨x :: _, _⟩ => x

/-! Example: Safe head: -/
example : safeHead ⟨['a', 'b', 'c'], by decide⟩ = 'a' := rfl

/-! The following integer inequalities have no non-negative solutions
We use the omega tactic to prove a contraction (False) from the set of linear
integer inequalities.

**Note:** x₁ = `x\1`

### General Constraints on Solutions

If we combine the two inequalities:

$-2x_1 + x_2 - 4x_3 \ge 3$
$3x_1 - 2x_2 + 7x_3 \ge -5$

We can eliminate $x_2$ by multiplying the first inequality by $2$ and adding it to the second:

$2(-2x_1 + x_2 - 4x_3) + (3x_1 - 2x_2 + 7x_3) \ge 2(3) + (-5)$
$-x_1 - x_3 \ge 1$
$x_1 + x_3 \le -1$

This tells us that any valid integer solution to this system must satisfy:

$$x_1 + x_3 \le -1$$

Consequently, at least one of $x_1$ or $x_3$ must be negative.

### Finding an Example Solution

Since $x_2$ is eliminated, we have some flexibility. If we set $x_3 = 0$, the constraint becomes $x_1 \le -1$.

If we choose $x_1 = -1$ and $x_3 = 0$, we can substitute these back into our original inequalities to find a valid $x_2$:

$-2(-1) + x_2 - 4(0) \ge 3 \implies 2 + x_2 \ge 3 \implies x_2 \ge 1$
$3(-1) - 2x_2 + 7(0) \ge -5 \implies -3 - 2x_2 \ge -5 \implies 2x_2 \le 2 \implies x_2 \le 1$
This forces $x_2 = 1$.

So, the values $x_1 = -1, x_2 = 1, x_3 = 0$ satisfy both inequalities:

$-2(-1) + 1 - 4(0) = 3 \ge 3$ (True)
$3(-1) - 2(1) + 7(0) = -5 \ge -5$ (True)

-/
example (x₁ x₂ x₃ : Int) (_ : x₁ ≥ 0) (_ : x₂ ≥ 0) (_ : x₃ ≥ 0) :
    -2 * x₁ + x₂ - 4 * x₃ ≥ 3
    → 3 * x₁ - 2 * x₂ + 7 * x₃ ≥ -5
    → False := by omega
