import Learning.Numerical
import Test.Util

namespace Test.Numerical

open Test.Util (assertEqual State)

/-- Run numerical tests. -/
def runTests (st : IO.Ref State) : IO Unit := do
  IO.println "\n[TEST] Testing Learning.Numerical"

  -- Positive number tests
  assertEqual st (toString (Pos.ofNat 7)) "7" "Pos.toString (Pos.ofNat 7)"
  assertEqual st (Pos.add (Pos.ofNat 2) (Pos.ofNat 3)) (Pos.ofNat 5) "Pos.add 2 3"
  assertEqual st ((Pos.ofNat 2) + (Pos.ofNat 3)) (Pos.ofNat 5) "Pos 2 + Pos 3"
  assertEqual st (toString ((Pos.ofNat 4) + (Pos.ofNat 5))) "9" "string Pos4 + Pos 5"
  assertEqual st (Pos.ofNat 0) Pos.one "Pos.ofNat 0"
  assertEqual st (Pos.mul (Pos.ofNat 1) (Pos.ofNat 2)) (Pos.ofNat 2) "Pos.mul 1 2"
  assertEqual st (Pos.mul (Pos.ofNat 3) (Pos.ofNat 4)) (Pos.ofNat 12) "Pos.mul 3 4"
  assertEqual st ((Pos.ofNat 3) * (Pos.ofNat 4)) (Pos.ofNat 12) "Pos 3 * Pos 4"

  -- Positive number equivalences
  let p1 := Pos.one
  let pn1 : { n : Nat // PosNat n } := ⟨1, by simp [PosNat]⟩
  assertEqual st (Pos.fromPosNat pn1) p1 "fromPosNat 1 == Pos.one"
  assertEqual st (Pos.toPosNat p1).val pn1.val "toPosNat Pos.one == 1"

  let p2 := Pos.succ Pos.one
  let pn2 : { n : Nat // PosNat n } := ⟨2, by simp [PosNat]⟩
  assertEqual st (Pos.fromPosNat pn2) p2 "fromPosNat 2 == Pos.succ Pos.one"
  assertEqual st (Pos.toPosNat p2).val pn2.val "toPosNat 2 == 2"

end Test.Numerical
