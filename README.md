# CS F301 Assignment 2 — Group 65
 
Logic and Functional Programming: two Prolog problems and two Scheme problems.
 
| Problem | File |
|---|---|
| P1: Department Assignment Puzzle | `code/65_q1.pl` |
| P2: Valid Arithmetic Equation | `code/65_q2.pl` |
| S1: Binary Tree Traversals | `code/65_q3.rkt` |
| S2: Conditional Insert into Nested List | `code/65_q4.rkt` |
 
## Layout
 
```
GROUP_ID_65/
  code/      65_q1.pl 65_q2.pl 65_q3.rkt 65_q4.rkt
  tests/     p1_tests.pl p2_tests.pl test_q3.rkt test_q4.rkt
  skills/    prolog-dev/SKILL.md scheme-dev/SKILL.md
  prompts/   P1.md P2.md S1.md S2.md
  P1_REPORT.md
```
 
## Environment
 
SWI-Prolog 9.x, Racket 8.x.
 
## Running
 
```bash
# Prolog
swipl -q -f code/65_q1.pl -g main -t halt
swipl -q -f code/65_q2.pl -g "all_equations([4,2,5,3], Es), print(Es)" -t halt
 
# Scheme (files contain only definitions; the grader appends calls)
racket code/65_q3.rkt
racket code/65_q4.rkt
```
 
## Tests
 
```bash
racket tests/test_q3.rkt
racket tests/test_q4.rkt
swipl -g run_tests -t halt tests/p1_tests.pl
swipl -g run_tests -t halt tests/p2_tests.pl
```
 
## Notes
 
- AI tools were used as allowed by the assignment. Prompts are logged word for word in `prompts/`, and the skill files are in `skills/`.
- P1 results (number of solutions for clues 1–8 and the added clue 9) are in `P1_REPORT.md`.
 
