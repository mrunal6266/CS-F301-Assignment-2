---
name: prolog-dev
description: Conventions, run commands, self-review checklist and known AI failure modes for writing SWI-Prolog 9.2.9 code for CS F301 Assignment 2 (P1 puzzle, P2 equations). Use for every Prolog predicate, test or review.
---

# prolog-dev

## Language and environment
- **SWI-Prolog 9.2.9** only. No other Prolog dialect, no extensions outside the allowed libraries.
- **Allowed libraries:** `lists`, `apply`, `yall`, `aggregate`. Nothing else (no `clpfd`, no `dcg/basics`, no `strings` library).
- Files contain **only definitions** (facts, rules, allowed `:- use_module(library(...))` lines). No top-level goals.

## Coding conventions
- **Naming:** predicates and atoms in `snake_case` (`count_solutions`, `clue`). Variables in `CamelCase` (`Solution`, `Dept`). Use `_` for values a clause does not need.
- **Declarative reading comment:** directly above every predicate, write one comment saying what is *true* when the predicate succeeds, not what it "does". Use the mode notation for arguments (`+` input, `-` output, `?` either):
  ```prolog
  % count_solutions(+Active, -N)
  % N is the number of solutions that satisfy exactly the clues in Active.
  count_solutions(Active, N) :- ...
  ```
- **One unit per answer:** produce exactly the predicate(s) asked for in the prompt, never the whole problem. Don't add helper predicates that weren't asked for unless you say why.
- **Quoted atoms:** anything starting with a capital letter or containing symbols must be quoted: `'Alex'`, `'Ben'`, `'Carla'`, `'Dana'`, `'c++'`, `'AI'`.
- **Generate, then test:** bind all variables first (for example with `permutation/2`), and run checks only afterwards.
- Keep clauses short. Put each goal on its own line when a body has more than two goals.

## How to run and test
Run `main`:
```bash
swipl -q -f id_q1.pl -g main -t halt
```
Run any other goal:
```bash
swipl -q -f id_q1.pl -g "count_solutions([1,2,3,4,5,6,7,8], N), print(N), nl" -t halt
swipl -q -f id_q2.pl -g "all_equations([4,2,5,3], Es), print(Es), nl" -t halt
```
- Test every predicate with the examples from the assignment PDF first, then with edge cases (empty list, one element, a goal that must fail).
- A goal that should fail must **fail cleanly**: no error, no infinite loop. Check it with:
  ```bash
  swipl -q -f id_q2.pl -g "( generate_equation([2,3,4], E) -> print(E) ; print(no) ), nl" -t halt
  ```
- Test files go in `tests/`, one per problem.

## Self-review checklist (apply before every answer)
- [ ] No `assert`, `asserta`, `assertz`, `retract` or `retractall`.
- [ ] No global variables: no `b_setval`, `b_getval`, `nb_setval` or `nb_getval`.
- [ ] No `:- initialization(...)` directive anywhere.
- [ ] No call to `halt/0` or `halt/1`.
- [ ] Only `lists`, `apply`, `yall` and `aggregate` are used.
- [ ] Negation (`\+`, `\==`, `\=`) is applied only to terms that are **ground** (fully bound) at that point.
- [ ] Every name and value atom is spelled and quoted exactly as the assignment says.
- [ ] Nothing is printed except the required output (no debug `print`/`format` lines left in).
- [ ] Printing predicates produce the output **once**, not once per solution.
- [ ] Every predicate has a declarative reading comment directly above it.
- [ ] Each example from the PDF has been run mentally or for real, and the result matches.
- [ ] P2 only: no building a string and parsing it back into a term to evaluate it; division is checked for zero divisor and exactness everywhere.

## Known AI failure modes in Prolog (check for these)
1. **Unquoted atoms.** Writing `Alex` (a variable, which silently matches anything) instead of `'Alex'`, or `c++` / `AI` instead of `'c++'` / `'AI'`. This produces wrong answers with no error.
2. **`\+` on unbound variables.** `\+ X = research` with X unbound always fails, because X *can* unify. Negation as failure means "not provable", not logical "not", so it only works on ground terms. Check after generating, never before.
3. **Missing cut / `once/1` in printing predicates.** `main` backtracks into a second solution and prints duplicate blocks. Use `once/1` or a cut after the first solution.
4. **Calling `halt`.** The grader adds `-t halt` itself; calling it in the file breaks other goals.
5. **Adding an initialization directive** to run `main` automatically. Not allowed.
6. **Hard-coding the answer** instead of deriving it from the clues.
7. **`findall` vs `bagof`.** `bagof/3` fails when there are no solutions, while `findall/3` gives `[]`. Use `findall` or `aggregate_all` when the count can be 0.
8. **Duplicate solutions** from overlapping clauses (for example two clauses that can both match the same case). Check counts with `aggregate_all(count, ...)`.
9. **Using `is` with unbound right-hand sides** (`X is Y + 1` before Y is bound), which raises an instantiation error.
10. **Integer vs float division.** `/` can give floats or rationals; use `//` with a `mod`/`rem` check for exact integer division (P2).
11. **Atoms vs strings vs code lists.** In SWI-Prolog 9, `"abc"` is a string. Return strings only where the assignment asks for them (P2), and atoms everywhere else.
12. **Inventing library predicates** that don't exist in SWI-Prolog, or using ones from libraries that aren't allowed. If unsure, say so instead of guessing.
13. **Infinite loops** from left recursion or generating unbounded lists. Every recursion must shrink something.
