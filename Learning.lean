import Learning.Basic
import Learning.HelloWorld
import Learning.Structure
import Learning.Numerical

open Learning.HelloWorld (greet)
open Learning.Basic (hitchHiker add1 maximum isAdult tonyAge)
open Learning.Structure (Point p1 p2 addPoints)
open Learning.Numerical (Pos)

/-- Showcase `Learning.Basic` module. -/
def demoBasic : IO Unit := do
  IO.println "--- Learning.Basic Demo ---"
  IO.println ("hitchHiker \"Alice\" 3: " ++ hitchHiker "Alice" 3)
  IO.println s!"add1 5: {add1 5}"
  IO.println s!"maximum 10 20: {maximum 10 20}"
  IO.println s!"isAdult tonyAge: {isAdult tonyAge}"

/-- Showcase `Learning.HelloWorld` module. -/
def demoHelloWorld (name : String) : IO Unit := do
  IO.println "--- Learning.HelloWorld Demo ---"
  IO.println (greet name)

/-- Showcase `Learning.Structure` module. -/
def demoStructure : IO Unit := do
  IO.println "--- Learning.Structure Demo ---"
  let p3 := addPoints p1 p2
  IO.println s!"p1: {repr p1}"
  IO.println s!"p2: {repr p2}"
  IO.println s!"addPoints p1 p2: {repr p3}"

/-- Entrypoint for the `learning` executable. -/
def main (args : List String) : IO Unit := do
  let name := match args with
    | x :: _ => x
    | []     => "World"

  demoHelloWorld name
  IO.println ""
  demoBasic
  IO.println ""
  demoStructure
