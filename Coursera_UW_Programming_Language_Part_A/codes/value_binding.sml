(* basic value bindings *)
(* Author: Zhiwei Liu *)
(* Email: cokeyliu@gmail.com *)

val x = 6;
val y = 6;

val z = (y + 2 ) + x - 52;

val abs_of_z = if z < 0 then ~z else z;

