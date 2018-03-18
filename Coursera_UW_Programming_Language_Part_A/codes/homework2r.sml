(* Dan Grossman, Coursera PL, HW2 Provided Code *)

(* if you use this function to compare two strings (returns true if the same string), then you avoid several of the functions in problem 1 having polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
    s1 = s2

(* put your solutions for problem 1 here *)
(* a. *)
fun all_except_option (s, ls )=
        case ls of
             [] => NONE
           | s0::ls' => if same_string(s, s0)
                        then SOME ls'
                        else case all_except_option(s, ls') of
                                  NONE => NONE
                                | SOME s1 => SOME(s0::s1)


(* b. *)
fun get_substitutions1 (substitutions, str) = 
    case substitutions of
	[] => []
      | x :: x' => case all_except_option (str, x) of 
		       NONE => get_substitutions1 (x', str)
		     | SOME i  => i @ get_substitutions1 (x', str)

(* c. *)
fun get_substitutions2 (substitutions, str) = 
        let fun loop (acc,substs_left) =
                case substs_left of
                        [] => acc
                      | x::xs => loop ((case all_except_option(str,x) of
                                        NONE => acc
                                      | SOME y => acc @ y), xs)
        in
                loop([],substitutions)
        end

(* d. *)
(* name of record: {first:string, middle:string, last:string} *)
fun similar_names (substitutions, {first = firstname, middle = middlename, last = lastname}) =
    let
	val subFirstNames = get_substitutions1 (substitutions, firstname)
    in
	let
	    fun substituteNames (subFirstNameList) =
		case subFirstNameList of
		    [] => []
		  | x :: x' => {first=x,middle=middlename,last=lastname}::substituteNames (x')
	in
          {first=firstname,middle=middlename,last=lastname}::substituteNames (subFirstNames)
	end
    end


(* you may assume that Num is always used with values 2, 3, ..., 10 though it will not really come up *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove

(* put your solutions for problem 2 here *)
(* a. *)
fun card_color (color, _) =
    case color of
	Clubs => Black
      | Diamonds => Red
      | Hearts => Red
      | Spades => Black

(* b. *)
fun card_value (_, value) =
    case value of
	Num x => x
      | Jack => 10
      | Queen => 10
      | King => 10
      | Ace => 11

(* c. *)
fun remove_card (cs, c, e) =
  case cs of
         [] => raise e
       | x::cs' => if x = c then cs' else x :: remove_card(cs',c,e)


(* d. *)
fun all_same_color lst =
   case lst of
        [] => true
      | [_] => true
      | head::neck::tail => card_color head = card_color neck 
                           andalso   all_same_color(neck::tail)

(* e. *)
fun sum_cards lst = 
    let
	fun sum_cards_sub (lst, total) = 
	    case lst of
		[] => total
 	      | x :: x' => sum_cards_sub (x', total + card_value x)
    in
	sum_cards_sub (lst, 0)
    end

(* f. *)
fun score (lst, goal) = 
    let
	val value = sum_cards lst
	val pre_score = if value > goal 
			then 3 * (value - goal) 
			else (goal - value)
    in
	if all_same_color lst
	then pre_score div 2
	else pre_score
    end

(* g. *)
fun officiate (cardList, moveList, goal) =
    let
	fun process_next_move (heldCards, nextMove, nextCards) = 
	    if sum_cards heldCards > goal
	    then score (heldCards, goal)
	    else
		case nextMove of
		    [] => score (heldCards, goal)
		  | x :: x' => case x of
				   Discard i => process_next_move (remove_card (heldCards, i, IllegalMove), x', nextCards)
				 | Draw => case nextCards of 
					       [] => score (heldCards, goal)
					     | y :: y' => process_next_move(y :: heldCards, x', y')
    in
	process_next_move ([], moveList, cardList)
    end
