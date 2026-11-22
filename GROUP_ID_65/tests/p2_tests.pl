% Tests for id_q2.pl (P2). Contains only definitions; it is loaded after
% id_q2.pl and started with run_tests/0.
%
% check(Name, Kind, Goal)
% Kind = yes: Goal must succeed, with no error.
% Kind = no:  Goal must fail cleanly, i.e. no solution and no error.

% ---------- expr_string/2: the PDF's parenthesis examples ----------
check(print_paren_left_lower, yes,
      expr_string(op('*', op('+', num(4), num(2)), num(3)), "(4+2)*3")).
check(print_no_paren_right_higher, yes,
      expr_string(op('+', num(4), op('*', num(2), num(3))), "4+2*3")).
check(print_left_same_level_no_paren, yes,
      expr_string(op('*', op('/', num(8), num(4)), num(2)), "8/4*2")).
check(print_right_same_level_paren, yes,
      expr_string(op('/', num(8), op('*', num(4), num(2))), "8/(4*2)")).
check(print_sub_left_assoc, yes,
      expr_string(op('-', op('-', num(1), num(2)), num(3)), "1-2-3")).
check(print_sub_right_paren, yes,
      expr_string(op('-', num(1), op('-', num(2), num(3))), "1-(2-3)")).
check(print_add_right_paren, yes,
      expr_string(op('+', num(1), op('+', num(2), num(3))), "1+(2+3)")).
check(print_add_left_assoc, yes,
      expr_string(op('+', op('+', num(1), num(2)), num(3)), "1+2+3")).
check(print_equation_side, yes,
      expr_string(op('*', num(2), op('-', num(5), num(3))), "2*(5-3)")).
check(print_both_operands_paren, yes,
      expr_string(op('*', op('+', num(1), num(2)), op('-', num(3), num(4))),
                  "(1+2)*(3-4)")).
check(print_number_is_string_no_paren, yes,
      ( expr_string(num(42), S), string(S), S == "42" )).
check(print_zero, yes,
      expr_string(num(0), "0")).
check(print_assoc_trees_differ, yes,
      ( expr_string(op('+', num(1), op('+', num(2), num(3))), S1),
        expr_string(op('+', op('+', num(1), num(2)), num(3)), S2),
        S1 \== S2 )).

% ---------- eval/2 ----------
check(eval_number, yes,
      eval(num(7), 7)).
check(eval_mixed, yes,
      eval(op('*', op('+', num(4), num(2)), num(3)), 18)).
check(eval_exact_division, yes,
      eval(op('/', num(8), num(4)), 2)).
check(eval_exact_division_nested, yes,
      eval(op('*', op('/', num(8), num(4)), num(2)), 4)).
check(eval_inexact_division_fails, no,
      eval(op('/', num(7), num(2)), _)).
check(eval_zero_divisor_fails, no,
      eval(op('/', num(5), num(0)), _)).
check(eval_zero_over_zero_fails, no,
      eval(op('/', num(0), num(0)), _)).
check(eval_zero_numerator_ok, yes,
      eval(op('/', num(0), num(5)), 0)).
check(eval_zero_divisor_from_subtree_fails, no,
      eval(op('/', op('+', num(1), num(2)), op('-', num(3), num(3))), _)).
check(eval_bad_division_deep_fails, no,
      eval(op('+', num(1),
              op('*', num(2),
                 op('-', num(9), op('/', num(7), num(2))))), _)).
check(eval_bad_division_times_zero_fails, no,
      eval(op('*', num(0), op('/', num(1), num(2))), _)).
check(eval_negative_intermediate, yes,
      eval(op('-', num(3), num(5)), -2)).
check(eval_negative_times, yes,
      eval(op('*', op('-', num(3), num(5)), num(4)), -8)).
check(eval_negative_exact_division, yes,
      eval(op('/', op('-', num(3), num(9)), num(3)), -2)).
check(eval_division_by_negative, yes,
      eval(op('/', num(6), op('-', num(1), num(4))), -2)).
check(eval_negative_inexact_fails, no,
      eval(op('/', op('-', num(3), num(8)), num(2)), _)).

% ---------- expr_tree/2 ----------
check(tree_empty_fails, no,
      expr_tree([], _)).
check(tree_single, yes,
      expr_tree([5], num(5))).
check(tree_count_2, yes,
      ( findall(T, expr_tree([1, 2], T), Ts), length(Ts, 4) )).
check(tree_count_3, yes,
      ( findall(T, expr_tree([1, 2, 3], T), Ts), length(Ts, 32) )).
check(tree_count_4, yes,
      ( findall(T, expr_tree([1, 2, 3, 4], T), Ts), length(Ts, 320) )).
check(tree_no_duplicates, yes,
      ( findall(T, expr_tree([1, 2, 3, 4], T), Ts),
        sort(Ts, Sorted), length(Ts, N), length(Sorted, N) )).
check(tree_both_associations_present, yes,
      ( expr_tree([1, 2, 3], op('+', op('+', num(1), num(2)), num(3))),
        expr_tree([1, 2, 3], op('+', num(1), op('+', num(2), num(3)))) )).

% ---------- generate_equation/2: PDF examples ----------
check(gen_4253_is_one_of_seven, yes,
      ( generate_equation([4, 2, 5, 3], E),
        string(E),
        memberchk(E, ["4*2-5=3", "4*2=5+3", "4-2=5-3", "4/2=5-3",
                      "4=2*(5-3)", "4=2+(5-3)", "4=2+5-3"]) )).
check(gen_4253_single_answer, yes,
      ( findall(E, generate_equation([4, 2, 5, 3], E), Es), length(Es, 1) )).
check(gen_248, yes,
      generate_equation([2, 4, 8], "2*4=8")).
check(gen_234_fails, no,
      generate_equation([2, 3, 4], _)).

% ---------- generate_equation/2: edge cases ----------
check(gen_empty_fails, no,
      generate_equation([], _)).
check(gen_one_element_fails, no,
      generate_equation([5], _)).
check(gen_one_element_zero_fails, no,
      generate_equation([0], _)).
check(gen_two_unequal_fails, no,
      generate_equation([1, 2], _)).
check(gen_two_equal, yes,
      generate_equation([1, 1], "1=1")).
check(gen_00, yes,
      generate_equation([0, 0], "0=0")).
check(gen_000_is_string, yes,
      ( generate_equation([0, 0, 0], E), string(E) )).
check(gen_zero_divisor_only_fails, no,
      generate_equation([5, 0], _)).
check(gen_negative_intermediate, yes,
      ( generate_equation([1, 5, 3, 7], E),
        all_equations([1, 5, 3, 7], Es),
        memberchk(E, Es) )).
check(gen_agrees_with_all, yes,
      forall(member(L, [[4, 2, 5, 3], [2, 4, 8], [2, 3, 4], [], [5], [0, 0],
                        [0, 0, 0], [3, 0, 0], [1, 5, 3, 7], [3, 5, 2, 0]]),
             ( generate_equation(L, E)
             -> ( all_equations(L, Es), memberchk(E, Es) )
             ;  all_equations(L, [])
             ))).

% ---------- all_equations/2: PDF examples ----------
check(all_4253, yes,
      all_equations([4, 2, 5, 3],
                    ["4*2-5=3", "4*2=5+3", "4-2=5-3", "4/2=5-3",
                     "4=2*(5-3)", "4=2+(5-3)", "4=2+5-3"])).
check(all_234_empty, yes,
      all_equations([2, 3, 4], [])).
check(all_248, yes,
      all_equations([2, 4, 8], ["2*4=8"])).

% ---------- all_equations/2: edge cases ----------
check(all_empty_list, yes,
      all_equations([], [])).
check(all_one_element, yes,
      all_equations([5], [])).
check(all_00, yes,
      all_equations([0, 0], ["0=0"])).
check(all_000_no_division_by_zero, yes,
      all_equations([0, 0, 0],
                    ["0*0=0", "0+0=0", "0-0=0", "0=0*0", "0=0+0", "0=0-0"])).
check(all_300_division_by_zero_excluded, yes,
      all_equations([3, 0, 0], ["3*0=0"])).
check(all_50_division_by_zero_excluded, yes,
      all_equations([5, 0], [])).
check(all_negative_intermediate_left, yes,
      ( all_equations([3, 5, 2, 0], Es), memberchk("3-5+2=0", Es) )).
check(all_negative_intermediate_both_sides, yes,
      ( all_equations([1, 5, 3, 7], Es), memberchk("1-5=3-7", Es) )).
check(all_sorted_without_duplicates, yes,
      forall(member(L, [[4, 2, 5, 3], [0, 0, 0], [1, 2, 3, 4], [1, 2, 3, 4, 5]]),
             ( all_equations(L, Es), sort(Es, Sorted), Es == Sorted ))).
check(all_elements_are_strings, yes,
      forall(member(L, [[4, 2, 5, 3], [0, 0, 0], [2, 4, 8]]),
             ( all_equations(L, Es), forall(member(E, Es), string(E)) ))).
check(all_equations_have_one_equals_sign, yes,
      ( all_equations([4, 2, 5, 3], Es),
        forall(member(E, Es),
               ( split_string(E, "=", "", Parts), length(Parts, 2) )) )).
check(all_no_spaces, yes,
      ( all_equations([4, 2, 5, 3], Es),
        forall(member(E, Es), \+ sub_string(E, _, _, _, " ")) )).
check(all_assoc_variants_both_counted, yes,
      ( all_equations([4, 2, 5, 3], Es),
        memberchk("4=2+(5-3)", Es),
        memberchk("4=2+5-3", Es) )).

% ---------- count_equations/2 ----------
check(count_4253, yes,
      count_equations([4, 2, 5, 3], 7)).
check(count_234, yes,
      count_equations([2, 3, 4], 0)).
check(count_248, yes,
      count_equations([2, 4, 8], 1)).
check(count_empty, yes,
      count_equations([], 0)).
check(count_one_element, yes,
      count_equations([5], 0)).
check(count_00, yes,
      count_equations([0, 0], 1)).
check(count_000, yes,
      count_equations([0, 0, 0], 6)).
check(count_300, yes,
      count_equations([3, 0, 0], 1)).
check(count_wrong_number_fails, no,
      count_equations([4, 2, 5, 3], 6)).
check(count_matches_all_equations, yes,
      forall(member(L, [[4, 2, 5, 3], [2, 3, 4], [2, 4, 8], [], [5],
                        [0, 0, 0], [1, 2, 3, 4]]),
             ( all_equations(L, Es), length(Es, N), count_equations(L, N) ))).

% passes(+Kind, :Goal)
% The goal behaves as the kind says: Kind yes means Goal succeeds without
% raising an error; Kind no means Goal has no solution and raises no error.
passes(yes, Goal) :-
    catch(once(Goal), _, fail).
passes(no, Goal) :-
    catch(\+ Goal, _, fail).

% run_tests
% Every check/3 passes. Prints one line per failing check and a summary.
% Fails if any check fails, so the swipl exit status is non-zero.
run_tests :-
    findall(Name, check(Name, _, _), All),
    length(All, Total),
    findall(Name,
            ( check(Name, Kind, Goal),
              \+ passes(Kind, Goal) ),
            Failed),
    length(Failed, NumFailed),
    forall(member(Name, Failed), format("FAIL: ~w~n", [Name])),
    Passed is Total - NumFailed,
    format("~d/~d tests passed~n", [Passed, Total]),
    Failed == [].

% Run (from the folder that contains code/ and tests/):
%   swipl -q -f code/65_q2.pl -l tests/p2_tests.pl -g run_tests -t halt