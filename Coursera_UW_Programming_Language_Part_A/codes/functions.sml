fun pow(x : int, y : int ) = 
  if y = 0
  then 1
  else x * pow(x, y - 1)

val b = [2,2,2,4]
val a = pow(2, 10) + 66
