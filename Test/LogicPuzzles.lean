import Test.Util
import Learning.LogicPuzzles.Perm
import Learning.LogicPuzzles.Breakfast

namespace Test.LogicPuzzles

open Test.Util
open Learning.LogicPuzzles.Perm
open Learning.LogicPuzzles.Breakfast

/-- Run logic puzzle tests. -/
def runTests (st : IO.Ref State) : IO Unit := do
  IO.println "\n[TEST] Testing Learning.LogicPuzzles"

  -- Perm count
  let perms123 := permutations [1, 2, 3]
  assertEqual st perms123.length 6 "permutations [1,2,3] length"

  -- Perm completeness
  let allPresent := perms123.all (fun p => p.contains 1 && p.contains 2 && p.contains 3)
  assertEqual st allPresent true "permutations completeness"

  -- zipWith4
  let z4 := zipWith4 (fun a b c d => a + b + c + d) [1,2] [10,20] [100,200] [1000,2000,3000]
  assertEqual st z4 [1111, 2222] "zipWith4 basic behaviour"

  -- Unique solution
  assertEqual st answers.length 1 "puzzle has exactly 1 solution"

  if answers.length == 1 then
    let sol := answers.head!
    
    let jenny := sol.find? (fun (n, _, _, _) => n == Name.Jenny)
    let jackie := sol.find? (fun (n, _, _, _) => n == Name.Jackie)
    let samantha := sol.find? (fun (n, _, _, _) => n == Name.Samantha)
    let judy := sol.find? (fun (n, _, _, _) => n == Name.Judy)

    assertEqual st (jenny == some (Name.Jenny, Drink.Tea, Meal.Toast, ToGo.Latte)) true "Jenny's assignment"
    assertEqual st (jackie == some (Name.Jackie, Drink.Orange, Meal.Pancakes, ToGo.Coffee)) true "Jackie's assignment"
    assertEqual st (samantha == some (Name.Samantha, Drink.Milk, Meal.Cereal, ToGo.Water)) true "Samantha's assignment"
    assertEqual st (judy == some (Name.Judy, Drink.Apple, Meal.Omelet, ToGo.Lemonade)) true "Judy's assignment"

end Test.LogicPuzzles
