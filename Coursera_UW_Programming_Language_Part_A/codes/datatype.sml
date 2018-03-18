datatype mytype = TwoInts of int*int
                | Strs of string
                | Pizza
(* TwoInts, Strs are functions while Pizza is a value. *)
val a = TwoInts (4,3)
val b = Strs (if true then "hi" else "hello") (* val b = Strs "hi" : mytype *)
val c = Pizza
val d = Strs (* val d = fn: string -> mytype *)

