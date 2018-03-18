fun sum_n_pairs(prs : (int*int) list) =
  if null prs
  then (0,0)
  else 
    let 
      fun sum_two_pairs(pr1 : int*int, pr2 : int*int) =
        (#1 pr1 + #1 pr2, #2 pr1 + #2 pr2)
    in
      sum_two_pairs(hd prs, sum_n_pairs(tl prs))
    end

fun sum_list(l : int list) = 
  if null l
  then 0
  else (hd l) + sum_list(tl l)

fun countdown(x : int) = 
  if x = 0
  then []
  else x::countdown(x-1)

fun append(xl : int list, yl : int list) =
  if null xl
  then yl
  else (hd xl) :: append(tl xl, yl)

fun firsts(l : ( int * int ) list ) = 
  if null l
  then []
  else #1 (hd l) :: firsts(tl l)

fun seconds(l : ( int * int ) list ) = 
  if null l
  then []
  else #1 (hd l) :: seconds(tl l)
