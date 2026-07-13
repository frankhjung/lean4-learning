import Learning.Structure
import Test.Util

open Learning.Structure
open Test.Util (assertEqual State mkState summary)

/-- Make `Point` values printable. -/
instance : ToString Point where
  toString p := s!"\{ x := {p.x}, y := {p.y} }"

namespace Test.Structure

/-- Run structure-related tests. -/
def runTests (st : IO.Ref State) : IO Unit := do
  IO.println "\n[TEST] Testing Learning.Structure"

  assertEqual st origin.x 0.0 "origin.x"
  assertEqual st origin.y 0.0 "origin.y"

  let expectedSum : Point := { x := 4.0, y := 6.0 }
  assertEqual st (addPoints p1 p2) expectedSum "addPoints p1 p2"

end Test.Structure
