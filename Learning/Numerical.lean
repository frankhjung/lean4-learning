/-!

# Numerical Basics

This file contains examples and definitions related to basic numerical systems:

- Linear inequalities verification using `omega`.
- Positive numbers defined as Peano-style numbers.
- Positive numbers defined as subtypes.

-/

/--
## Linear Inequalities

The following integer inequalities have no non-negative solutions. We use the
omega tactic to prove a contraction (False) from the set of linear integer
inequalities.

**Note:** x₁ = `x\1`

### General Constraints on Solutions

If we combine the two inequalities:

$-2x_1 + x_2 - 4x_3 \ge 3$

$3x_1 - 2x_2 + 7x_3 \ge -5$

We can eliminate $x_2$ by multiplying the first inequality by $2$ and adding it
to the second:

$2(-2x_1 + x_2 - 4x_3) + (3x_1 - 2x_2 + 7x_3) \ge 2(3) + (-5)$

$-x_1 - x_3 \ge 1$

$x_1 + x_3 \le -1$

This tells us that any valid integer solution to this system must satisfy:

$x_1 + x_3 \le -1$

Consequently, at least one of $x_1$ or $x_3$ must be negative.

### Finding an Example Solution

Since $x_2$ is eliminated, we have some flexibility. If we set $x_3 = 0$, the
constraint becomes $x_1 \le -1$.

If we choose $x_1 = -1$ and $x_3 = 0$, we can substitute these back into our
original inequalities to find a valid $x_2$:

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

/-!

## Positive Numbers (Peano)

The following example shows how to create a class of positive numbers using
an `inductive` type similar to Peano numbers.
Notes:

- the `+` operator is defined for `Nat`, but not for `Pos`.
- the `OfNat` class is used to help define these positive numbers

--/

/-- Type Class: Positive numbers. -/
inductive Pos : Type where
  /-- The base case for positive numbers: one. -/
  | one : Pos
  /-- The successor case for positive numbers. -/
  | succ : Pos → Pos
deriving BEq

/-- Convert a natural number to a positive number, treating `0` as `Pos.one`. -/
def Pos.ofNat : Nat → Pos
  | 0 => Pos.one
  | 1 => Pos.one
  | n + 2 => Pos.succ (Pos.ofNat (n + 1))

/-- Convert a natural number to a positive number. -/
instance : OfNat Pos (n + 1) where
  ofNat := Pos.ofNat n

/-- Convert a positive number to a natural number. -/
def Pos.toNat : Pos → Nat
  | Pos.one => 1                -- base case
  | Pos.succ n => n.toNat + 1   -- inductive step

/-- Class ToString: Convert a Pos to a string. -/
instance : ToString Pos where
  toString := toString ∘ Pos.toNat

/-- Class Plus: Adds two numbers. -/
class Plus (α : Type) where
  /-- The addition operation for the `Plus` class. -/
  plus : α → α → α

/-- Instance Plus: Add two natutal numbers. -/
instance : Plus Nat where
  plus := Nat.add

/-- Def Pos.add: Add two positive numbers. -/
def Pos.add : Pos → Pos → Pos
  | Pos.one, y => Pos.succ y -- base case
  | Pos.succ x, y => Pos.succ (x.add y) -- inductive step

/-- Multiplication for positive numbers. -/
def Pos.mul : Pos → Pos → Pos
  | Pos.one, x => x -- base case
  | Pos.succ x, y => Pos.add (x.mul y) y -- inductive step, add y x times

/-- Define (+) operator for Pos. -/
instance : Add Pos where
  add := Pos.add

/-- Define (*) operator for Pos. -/
instance : Mul Pos where
  mul := Pos.mul

/-!

## Positive Numbers (subtype)

Another way to define a type for positive integers is by subtyping:

-/

/-- Type Class: Positive numbers using subtype. -/
def PosNat (n : Nat) : Prop := n > 0

/-- Convert `Pos` to `PosNat` subtype. -/
def Pos.toPosNat (p : Pos) : { n : Nat // PosNat n } :=
  ⟨p.toNat, by induction p <;> simp [toNat, PosNat, *]⟩

/-- Convert `PosNat` subtype to `Pos`. -/
def Pos.fromPosNat (n : { n : Nat // PosNat n }) : Pos :=
  Pos.ofNat n.val
