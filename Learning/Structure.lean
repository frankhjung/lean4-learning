namespace Learning.Structure

/-! Small geometry utilities: a 2D `Point` structure and helpers.

This file defines a simple `Point` structure with floating-point
coordinates and a few example values and operations used in tests.
-/

/-- A 2D point with `x` and `y` coordinates as `Float`. -/
structure Point where
  /-- The horizontal coordinate. -/
  x : Float
  /-- The vertical coordinate. -/
  y : Float
  deriving BEq, Inhabited

instance : Repr Point where
  reprPrec p _prec :=
    repr s!"Point(\{x := {p.x}, y := {p.y}})"

/-- The origin point `(0.0, 0.0)`. -/
def origin : Point := { x := 0.0, y := 0.0 }

/-- Add two points coordinate-wise and return the resulting `Point`. -/
def addPoints (p1 : Point) (p2 : Point) : Point :=
  { x := p1.x + p2.x, y := p1.y + p2.y }

/-- Example point used in tests and examples. -/
def p1 : Point := { x := 3.0, y := 4.0 }
/-- Example point used in tests and examples. -/
def p2 : Point := { x := 1.0, y := 2.0 }
