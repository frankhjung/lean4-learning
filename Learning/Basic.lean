/-!

# Basics

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

-- Example: Check adult status
example : isAdult tonyAge = true := rfl
example : isAdult lisaAge = false := rfl

/-- Safe head: equivalent to `List.head`, but requires a proof of
non-emptiness. -/
def safeHead {α : Type} (xs : { l : List α // l ≠ []}) : α :=
  match xs with
  | ⟨[], h⟩ => False.elim (h rfl)
  | ⟨x :: _, _⟩ => x

-- Example: Safe head
example : safeHead ⟨['a', 'b', 'c'], by decide⟩ = 'a' := rfl
