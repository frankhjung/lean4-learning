import Learning.Structure
import Test.Util
import Learning.Structure

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

  let p : PositiveQuadrant :=
    PositiveQuadrant.mk' 1.0 2.0 (by native_decide) (by native_decide)
  assertEqual st (p.x'.val) 1.0 "PositiveQuadrant.x value"
  assertEqual st (p.y'.val) 2.0 "PositiveQuadrant.y value"

  IO.println "[OK] all structure tests passed"

end Test.Structure
