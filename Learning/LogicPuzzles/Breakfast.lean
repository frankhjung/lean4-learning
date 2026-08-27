import Learning.LogicPuzzles.Perm

/-!
# Breakfast at Tiffany's Logic Puzzle

Four close friends decided to get together one morning for breakfast and
conversation. Jenny, whose turn it was to pick the location, decided on a
fancy hotel in downtown NYC. Each of the women had a small meal served with
a drink (one of the drinks was an Orange Juice) and they talked about their
busy week. Their conversation continued longer than expected and each of
the women had to rush out of the hotel. Before leaving, they each got
another drink to go (one of which was a latte). Can you figure out which
woman ordered which drink for breakfast, what they ate, and which drink
they took to go?

Reference:
<https://www.ahapuzzles.com/logic/logic-puzzles/breakfast-at-tiffanys/>
-/

namespace Learning.LogicPuzzles.Breakfast

open Learning.LogicPuzzles.Perm (permutations zipWith4)

/-- Friend names. -/
inductive Name | Jenny | Jackie | Samantha | Judy
  deriving BEq, DecidableEq, Repr, Inhabited

/-- Breakfast drinks. -/
inductive Drink | Orange | Apple | Tea | Milk
  deriving BEq, DecidableEq, Repr, Inhabited

/-- Breakfast meals. -/
inductive Meal | Toast | Omelet | Pancakes | Cereal
  deriving BEq, DecidableEq, Repr, Inhabited

/-- To-go drinks. -/
inductive ToGo | Lemonade | Water | Coffee | Latte
  deriving BEq, DecidableEq, Repr, Inhabited

/-- Convert Name to String. -/
def Name.toString : Name → String
  | Jenny    => "Jenny"
  | Jackie   => "Jackie"
  | Samantha => "Samantha"
  | Judy     => "Judy"

instance : ToString Name := ⟨Name.toString⟩

/-- Convert Drink to String. -/
def Drink.toString : Drink → String
  | Orange => "Orange"
  | Apple  => "Apple"
  | Tea    => "Tea"
  | Milk   => "Milk"

instance : ToString Drink := ⟨Drink.toString⟩

/-- Convert Meal to String. -/
def Meal.toString : Meal → String
  | Toast    => "Toast"
  | Omelet   => "Omelet"
  | Pancakes => "Pancakes"
  | Cereal   => "Cereal"

instance : ToString Meal := ⟨Meal.toString⟩

/-- Convert ToGo to String. -/
def ToGo.toString : ToGo → String
  | Lemonade => "Lemonade"
  | Water    => "Water"
  | Coffee   => "Coffee"
  | Latte    => "Latte"

instance : ToString ToGo := ⟨ToGo.toString⟩

/-- A single person's assignment: Name, Drink, Meal, ToGo. -/
structure Assignment where
  /-- Person's name. -/
  name  : Name
  /-- Drink ordered with breakfast. -/
  drink : Drink
  /-- Meal ordered for breakfast. -/
  meal  : Meal
  /-- Beverage ordered to go. -/
  toGo  : ToGo
  deriving BEq, DecidableEq, Repr, Inhabited

/-- All possible names in fixed order. -/
def names : List Name := [Name.Jenny, Name.Jackie, Name.Samantha, Name.Judy]

/-- All possible drinks. -/
def drinks : List Drink := [Drink.Orange, Drink.Apple, Drink.Tea, Drink.Milk]

/-- All possible meals. -/
def meals : List Meal := [Meal.Toast, Meal.Omelet, Meal.Pancakes, Meal.Cereal]

/-- All possible to-go drinks. -/
def togos : List ToGo := [ToGo.Lemonade, ToGo.Water, ToGo.Coffee, ToGo.Latte]

/-- All 13,824 possible assignment configurations. -/
def candidates : List (List Assignment) :=
  (permutations drinks).flatMap fun ds =>
  (permutations meals).flatMap fun ms =>
  (permutations togos).map fun ts =>
  zipWith4 Assignment.mk names ds ms ts

/-- 1. Samantha had a bowl of cereal but not a Latte. -/
def clue1 (sol : List Assignment) : Bool :=
  match sol.find? (·.name == Name.Samantha) with
  | some a => a.meal == Meal.Cereal && a.toGo != ToGo.Latte
  | none   => false

/--
2. The friend who ordered the potato pancakes also ordered a coffee to
   go but didn't have an ice tea.
-/
def clue2 (sol : List Assignment) : Bool :=
  match sol.find? (·.meal == Meal.Pancakes) with
  | some a => a.toGo == ToGo.Coffee && a.drink != Drink.Tea
  | none   => false

/--
3. The woman who ordered the omelet had apple juice to drink but she
   wasn't Jenny.
-/
def clue3 (sol : List Assignment) : Bool :=
  match sol.find? (·.meal == Meal.Omelet) with
  | some a => a.drink == Drink.Apple && a.name != Name.Jenny
  | none   => false

/--
4. Of the two friends who ordered the orange juice and the ice tea,
   one was Jackie and the other was the friend who ordered the French
   toast.
-/
def clue4 (sol : List Assignment) : Bool :=
  let jackieData := sol.find? (·.name == Name.Jackie)
  let toastData := sol.find? (·.meal == Meal.Toast)
  match jackieData, toastData with
  | some a1, some a2 =>
      (a1.drink == Drink.Orange && a2.drink == Drink.Tea) ||
      (a1.drink == Drink.Tea && a2.drink == Drink.Orange)
  | _, _ => false

/--
5. The friend who ordered a bottle of water to go didn't order
   orange juice.
-/
def clue5 (sol : List Assignment) : Bool :=
  match sol.find? (·.toGo == ToGo.Water) with
  | some a => a.drink != Drink.Orange
  | none   => false

/-- 6. Judy ordered a lemonade to go. -/
def clue6 (sol : List Assignment) : Bool :=
  match sol.find? (·.name == Name.Judy) with
  | some a => a.toGo == ToGo.Lemonade
  | none   => false

/-- All 6 breakfast puzzle clue predicates in sequence. -/
def clues : List (List Assignment → Bool) :=
  [clue1, clue2, clue3, clue4, clue5, clue6]

/-- True if all 6 clues are satisfied. -/
def isValid (sol : List Assignment) : Bool :=
  clues.all (· sol)

/-- Returns all valid solutions. Expected to yield exactly 1. -/
def answers : List (List Assignment) :=
  candidates.filter isValid

/-- Pad a string on the right with spaces to a given length using FBIP. -/
def padRight (s : String) (len : Nat) : String :=
  if s.length >= len then s else s.pushn ' ' (len - s.length)

/-- Format an Assignment as a row in a Markdown table. -/
def formatAssignment (a : Assignment) : String :=
  let ns := padRight (toString a.name) 8
  let ds := padRight (toString a.drink) 8
  let ms := padRight (toString a.meal) 8
  let ts := padRight (toString a.toGo) 8
  s!"| {ns} | {ds} | {ms} | {ts} |"

/-- Formal compile-time proof that the puzzle has a unique solution. -/
theorem answers_length_eq_one : answers.length = 1 := by
  native_decide

/-- Print the puzzle solution as a text table. -/
def printSolution : IO Unit := do
  match answers with
  | sol :: _ =>
    IO.println "| Name     | Drink    | Meal     | To Go    |"
    IO.println "|----------|----------|----------|----------|"
    for a in sol do
      IO.println (formatAssignment a)
  | [] =>
    IO.println "No valid solution found."

end Learning.LogicPuzzles.Breakfast
