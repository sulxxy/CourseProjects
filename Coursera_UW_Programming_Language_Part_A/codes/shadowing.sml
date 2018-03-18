(* shadowing *)
(* Author: Zhiwei Liu *)
(* Email: cokeyliu@gmail.com *)

val x = 5;
val y = x + 5;
val x = 6; (* x is shadowed to 6 *)
val z = x * 3;
