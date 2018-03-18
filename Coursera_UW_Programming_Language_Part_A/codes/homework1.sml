(* In all problems, a “date” is an SML value of type int*int*int, where the first part is the year, the second part is the month, and the third part is the day. A “reasonable” date has a positive year, a month between 1 and 12, and a day no greater than 31 (or less depending on the month). Your solutions need to work correctly only for reasonable dates, but do not check for reasonable dates(that is a challenge problem) and many of your functions will naturally work correctly for some/all non-reasonable dates. A “day of year” is a number from 1 to 365 where, for example, 33 represents February 2. (We ignore leap years except in one challenge problem.) *)

(* 1. Write a function is_older that takes two dates and evaluates to true or false. It evaluates to true if the first argument is a date that comes before the second argument. (If the two dates are the same, the result is false.) *)
fun is_older(d1 : int * int * int, d2 : int * int * int) = 
        ((#1 d2) - (#1 d1)) * 365 + ((#2 d2) - (#2 d1)) * 30 + ((#3 d2) - (#3 d1)) > 0

(* 2. Write a function number_in_month that takes a list of dates and a month(i.e., an int) and returns how many dates in the list are in the given month.*)
fun number_in_month(dates : (int * int * int) list, m : int) =
        if null dates
        then 0
        else 
                let val tmp = #2 (hd dates) 
                val cnt = number_in_month(tl dates, m)
                in if  tmp = m
                   then cnt + 1
                   else cnt
                end 

(* 3. Write a function number_in_months that takes a list of dates and a list of months (i.e., an int list) and returns the number of dates in the list of dates that are in any of the months in the list of months. Assume the list of months has no number repeated. Hint: Use your answer to the previous problem.*)
fun number_in_months(dates : (int * int * int ) list, ms : int list) = 
        if null ms
        then 0
        else number_in_month(dates, hd ms) + number_in_months(dates, tl ms)

(* 4. Write a function dates_in_month that takes a list of dates and a month (i.e., an int) and returns a list holding the dates from the argument list of dates that are in the month. The returned list should contain dates in the order they were originally given. *)
fun dates_in_month(dates : (int * int * int) list, month : int) = 
        if null dates
        then []
        else
                let val tl_dates = dates_in_month(tl dates, month)
                in if (#2 (hd dates)) = month
                   then (hd dates) :: tl_dates 
                   else tl_dates
                end

(* 5. Write a function dates_in_months that takes a list of dates and a list of months (i.e., an int list) and returns a list holding the dates from the argument list of dates that are in any of the months in the list of months. Assume the list of months has no number repeated. Hint: Use your answer to the previous problem and SML’s list-append operator (@).*)
fun dates_in_months(dates : (int * int * int) list, ms : int list) = 
        if null ms
        then []
        else (dates_in_month(dates, hd ms)) @ dates_in_months(dates, tl ms)

(* 6. Write a function get_nth that takes a list of strings and an int n and returns the nth element of the list where the head of the list is 1st. Do not worry about the case where the list has too few elements: your function may apply hd or tl to the empty list in this case, which is okay.*)
fun get_nth (ss : string list, n : int) = 
        if n = 1
        then hd ss
        else get_nth(tl ss, n - 1)
 
(* 7. Write a function date_to_string that takes a date and returns a string of the form January 20, 2013 (for example). Use the operator ^ for concatenating strings and the library function Int.toString for converting an int to a string. For producing the month part, do not use a bunch of conditionals. Instead, use a list holding 12 strings and your answer to the previous problem. For consistency, put a comma following the day and use capitalized English month names: January, February, March, April, May, June, July, August, September, October, November, December. *)
fun date_to_string (date : int * int * int ) =
        let val months_list = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "Noveber", "December"]
        in get_nth(months_list, #2 date) ^ " " ^ (Int.toString (#3 date)) ^ ", " ^ (Int.toString (#1 date))
        end

(* 8. Write a function number_before_reaching_sum that takes an int called sum, which you can assume is positive, and an int list, which you can assume contains all positive numbers, and returns an int. You should return an int n such that the first n elements of the list add to less than sum, but the first n + 1 elements of the list add to sum or more. Assume the entire list sums to more than the passed in value; it is okay for an exception to occur if this is not the case. *)
fun number_before_reaching_sum(sum : int, digit_list : int list) = 
        if sum <= hd digit_list
        then 0
        else 1 + number_before_reaching_sum(sum - (hd digit_list), tl digit_list)

(* 9. Write a function what_month that takes a day of year (i.e., an int between 1 and 365) and returns what month that day is in (1 for January, 2 for February, etc.). Use a list holding 12 integers and your answer to the previous problem. *)
fun what_month(day : int) =
        let val month_length = [31,28,31,30,31,30,31,31,30,31,30,31]
        in number_before_reaching_sum(day, month_length) + 1
        end

(* 10. Write a function month_range that takes two days of the year day1 and day2 and returns an int list [m1,m2,...,mn] where m1 is the month of day1, m2 is the month of day1+1, ..., and mn is the month of day day2. Note the result will have length day2 - day1 + 1 or length 0 if day1>day2. *)
fun month_range(day1 : int, day2 : int) =
        if day1 > day2
        then []
        else what_month(day1) :: month_range(day1 + 1, day2)

(* 11. Write a function oldest that takes a list of dates and evaluates to an (int*int*int) option. It evaluates to NONE if the list has no dates and SOME d if the date d is the oldest date in the list. *)
fun oldest(dates : (int * int * int) list) = 
        if null dates
        then NONE
        else 
                let val tl_ans = oldest(tl dates)
                in if isSome tl_ans andalso is_older(valOf tl_ans , hd dates)
                   then tl_ans
                   else SOME (hd dates)
                end

(* 12. Challenge Problem: Write functions number_in_months_challenge and dates_in_months_challenge that are like your solutions to problems 3 and 5 except having a month in the second argument multiple times has no more effect than having it once. (Hint: Remove duplicates, then use previous work. *)
fun remove_duplicates(ls : int list) =
        let 
              fun is_digit_in_list(digit : int, ls : int list) =
                if null ls
                then false
                else if digit = hd ls
                then true
                else is_digit_in_list(digit, tl ls)
        in
              if null ls
              then []
              else 
                      let
                              val tl_ans = remove_duplicates(tl ls)
                      in
                              if is_digit_in_list(hd ls, tl_ans)
                              then tl_ans
                              else (hd ls) :: tl_ans
                      end
        end
fun number_in_months_challenge(dates : (int * int * int) list, ms : int list) =
        number_in_months(dates, remove_duplicates(ms))

fun dates_in_months_challenge(dates : (int * int * int) list, ms : int list) = 
        dates_in_months(dates, remove_duplicates(ms))

(* 13. Challenge Problem: Write a function reasonable_date that takes a date and determines if it describes a real date in the common era. A “real date” has a positive year (year 0 did not exist), a month between 1 and 12, and a day appropriate for the month. Solutions should properly handle leap years. Leap years are years that are either divisible by 400 or divisible by 4 but not divisible by 100. (Do not worry about days possibly lost in the conversion to the Gregorian calendar in the Late 1500s.) *)
fun reasonable_date(date : int * int * int) =
        let
                val month_length1 = [1,3,5,7,8,10,12]
                val month_length2 = [4,6,9,11]
                fun is_digit_in_list(digit : int, ls : int list) = 
                        if null ls
                        then false
                        else if digit = hd ls
                        then true
                        else is_digit_in_list(digit, tl ls)
                fun is_leap_year(year : int) =
                        (year mod 4 = 0 andalso year mod 100 <> 0) orelse (year mod 400 = 0)
        in
                if (#1 date > 0) andalso (#2 date >= 1) andalso (#2 date <= 12)
                then 
                        if is_digit_in_list(#2 date, month_length1) 
                        then 
                          ((#3 date) >= 1) andalso ((#3 date) <= 31)
                        else if is_digit_in_list(#2 date, month_length2) 
                        then 
                          ((#3 date) >= 1) andalso ((#3 date) <= 30)
                        else (* the date is in Februray *)
                          if is_leap_year(#1 date)
                          then
                            ((#3 date) >= 1) andalso ((#3 date) <= 29)
                          else
                            ((#3 date) >= 1) andalso ((#3 date) <= 28)
                else false
        end
