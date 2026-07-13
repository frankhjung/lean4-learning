namespace Learning.HelloWorld

/-! Small utilities for greeting examples.

This module provides a simple example `name` constant and a `greet` function
used by the `learning` executable and tests. -/

/-- An example default name used in greeting examples. -/
def name := "Lean 4"

/-- Greet the provided `name` with a "Hello World" message.
    Returns a `String` of the form "Hello World, <name>!". -/
def greet : String → String
  | name => s!"Hello World, {name}!"
