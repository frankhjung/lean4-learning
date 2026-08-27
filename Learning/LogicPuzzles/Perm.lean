namespace Learning.LogicPuzzles.Perm

/--
Return all possible ways to insert an element `x` into a list `xs`.

For example, `insertions 1 [2, 3]` yields `[[1, 2, 3], [2, 1, 3], [2, 3, 1]]`.
-/
def insertions (x : α) : List α → List (List α)
  | [] => [[x]]
  | y :: ys => (x :: y :: ys) :: (insertions x ys).map (y :: ·)

/--
Return all permutations of a list `xs`.

For example, `permutations [1, 2]` yields `[[1, 2], [2, 1]]`.
-/
def permutations : List α → List (List α)
  | [] => [[]]
  | x :: xs => (permutations xs).flatMap (insertions x)

/--
Zip four lists together with a function `f`.

Truncates to the length of the shortest input list.
-/
def zipWith4 (f : α → β → γ → δ → ε) :
    List α → List β → List γ → List δ → List ε
  | a :: as, b :: bs, c :: cs, d :: ds => f a b c d :: zipWith4 f as bs cs ds
  | _, _, _, _                         => []

end Learning.LogicPuzzles.Perm
