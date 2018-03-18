(* Dan Grossman, Coursera PL, HW2 Provided Code *)

(* if you use this function to compare two strings (returns true if the same string), then you avoid several of the functions in problem 1 having polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
      s1 = s2

(* solutions for problem 1 here *)
(* (a) Write a function all_except_option, which takes a string and a string list. Return NONE if the string is not in the list, else return SOME lst where lst is identical to the argument list except the string is not in it. You may assume the string is in the list at most once. Use same_string, provided to you, to compare strings. Sample solution is around 8 lines. *)
fun all_except_option (s : string, sl : string list) =
        case sl of
             [] => NONE
           | s0::sl' => if same_string(s0, s) 
                       then SOME sl'
                       else all_except_option(s, sl')

(* (b) Write a function get_substitutions1, which takes a string list list (a list of list of strings, the substitutions) and a string s and returns a string list. The result has all the strings that are in some list in substitutions that also has s, but s itself should not be in the result. *)
fun get_substititions1(sll : string list list, s : string) = 
        case sll of
            [] => []
           |sl0::sll' => if all_except_option(s, s10)
                         then all_except_option(s, s10) @ get_substititions1(sll', s) 
                         else get_substititions1(sll', s)

(* (c) Write a function get_substitutions2, which is like get_substitutions1 except it uses a tail-recursive local helper function.*)
fun get_substititions2(sll : string list list, s : string) = 
        case sll of
            [] => []
           |sl0::sll' => if all_except_option(s, s10)
                         then all_except_option(s, s10) @ get_substititions2(sll', s) 
                         else get_substititions2(sll', s)

(* (d) Write a function similar_names, which takes a string list list of substitutions (as in parts (b) and (c)) and a full name of type {first:string,middle:string,last:string} and returns a list of full names (type {first:string,middle:string,last:string} list). The result is all the full names you can produce by substituting for the first name (and only the first name) using substitutions and parts (b) or (c). The answer should begin with the original name (then have 0 or more other names). *)
fun similar_name (sll : string list list, full_name : {first:string, middle:string, last:string}) =
        let val substitution_list = get_substititions2(:) 
                       

(* you may assume that Num is always used with values 2, 3, ..., 10 though it will not really come up *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove

(* solutions for problem 2 here *)
