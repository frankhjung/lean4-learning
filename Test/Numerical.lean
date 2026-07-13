import Learning.Numerical
import Test.Util

namespace Test.Numerical

open Learning.Numerical
open Test.Util (assertEqual assertForAll State)

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

  -- Property-based tests (bounded exhaustive)
  let vals := (List.range 20).map Pos.ofNat
  let pairs := vals.flatMap fun a =>
    vals.map fun b => (a, b)
  let triples := vals.flatMap fun a =>
    vals.flatMap fun b =>
      vals.map fun c => (a, b, c)

  assertForAll st pairs
    (fun (a, b) => (a + b).toNat == (b + a).toNat)
    "Pos.add is commutative"
  assertForAll st triples
    (fun (a, b, c) =>
      ((a + b) + c).toNat == (a + (b + c)).toNat)
    "Pos.add is associative"
  assertForAll st pairs
    (fun (a, b) => (a * b).toNat == (b * a).toNat)
    "Pos.mul is commutative"
  assertForAll st triples
    (fun (a, b, c) =>
      (a * (b + c)).toNat == (a * b + a * c).toNat)
    "Pos.mul distributes over Pos.add"

end Test.Numerical
