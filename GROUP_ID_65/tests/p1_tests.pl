% Tests for P1 (GROUP_ID_65_q1.pl), written with SWI-Prolog's plunit.
% Run from the repo root:
%   swipl -q -f GROUP_ID_65/code/GROUP_ID_65_q1.pl -s GROUP_ID_65/tests/p1_tests.pl -g run_tests -t halt

:- use_module(library(plunit)).
:- use_module(library(lists)).
:- use_module(library(aggregate)).

% format_solution(+S, -Str)
% Str is the text main/0 should print for solution S.
format_solution(S, Str) :-
    with_output_to(string(Str),
        forall(member(p(N, D, L, P), S),
               format("~w = [~w, ~w, ~w]~n", [N, D, L, P]))).

:- begin_tests(p1_main).

% main prints exactly four lines, in the order Alex, Ben, Carla, Dana.
test(four_lines_in_order) :-
    with_output_to(string(Out), main),
    split_string(Out, "\n", "", [L1, L2, L3, L4, ""]),
    string_concat("Alex = [",  _, L1),
    string_concat("Ben = [",   _, L2),
    string_concat("Carla = [", _, L3),
    string_concat("Dana = [",  _, L4).

% main's output is exactly the formatting of one valid solution of clues 1-8.
test(output_is_a_valid_solution) :-
    with_output_to(string(Out), main),
    findall(Str, (solution([1,2,3,4,5,6,7,8], S), format_solution(S, Str)), Valid),
    memberchk(Out, Valid).

% Quoted atoms are printed without quotes (c++ not 'c++', AI not 'AI').
test(no_quotes_in_output) :-
    with_output_to(string(Out), main),
    \+ sub_string(Out, _, _, _, "'").

:- end_tests(p1_main).

:- begin_tests(p1_counts).

test(no_clues_gives_all_assignments) :-
    count_solutions([], N), N =:= 13824.

test(clues_1_to_8) :-
    count_solutions([1,2,3,4,5,6,7,8], N), N =:= 3.

test(clues_1_to_9_unique) :-
    count_solutions([1,2,3,4,5,6,7,8,9], N), N =:= 1.

% Every clue on its own removes some assignments.
test(each_clue_reduces_count, [forall(between(1, 9, C))]) :-
    count_solutions([C], N), N < 13824.

% Exact single-clue counts (checked by hand).
test(single_clue_counts,
     [forall(member(C-E, [1-7776, 2-7776, 3-3456, 4-2592, 5-3456,
                          6-7776, 7-5184, 8-2592, 9-3456]))]) :-
    count_solutions([C], N), N =:= E.

% Clue 9 is true in exactly one of the solutions of clues 1-8.
test(clue9_true_in_exactly_one) :-
    aggregate_all(count, (solution([1,2,3,4,5,6,7,8], S), clue(9, S)), 1).

% Order of Active does not matter.
test(active_order_irrelevant) :-
    count_solutions([8,7,6,5,4,3,2,1], N), N =:= 3.

:- end_tests(p1_counts).