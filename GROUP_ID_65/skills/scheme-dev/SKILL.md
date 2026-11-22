---
name: scheme-dev
description: Reusable instruction pack for Scheme/Racket development in CS F301 Assignment 2.
---

# scheme-dev Skill

## Language and Version

- Language: **Racket** (a dialect of Scheme)
- Version: **Racket 8.x**
- Module language: `#lang racket/base` — every file must start with this header

## Coding Conventions

### File Structure
- First line: `#lang racket/base`
- Second line (if needed): `(provide (all-defined-out))` for test imports
- Only `define` forms at the top level — no bare calls, no printed output on load
- One function per logical section; each section has a block comment header

### Naming
- Function names: `kebab-case` (e.g., `insert-if-short`, `my-length`)
- Predicates end in `?` (e.g., `len-ok?`, `null?`, `pair?`)
- Accumulator parameters: suffix `-acc` or `acc` (e.g., `my-length-iter l acc`)

### Comments
- Each function has a type signature comment: `; name: type -> type`
- Each function has a declarative reading: one sentence explaining what it computes, not how
- Inline comments on non-obvious lines (e.g., `; measure BEFORE any change`)

### Recursion Style
- Prefer **tail recursion** with an accumulator for linear traversals (e.g., `my-length`)
- Use plain structural recursion when building a new list (e.g., `my-map`, `insert-if-short`)
- Pass all state through function arguments — no global mutation, no `set!`

## Allowed Built-ins (S2: 65_q4.rkt)

| Category     | Allowed identifiers |
|---|---|
| Predicates   | `null?`, `pair?`, `number?`, `symbol?`, `boolean?`, `equal?`, `<`, `>`, `=`, `<=`, `>=`, `zero?`, `not`, `or`, `and` |
| List ops     | `car`, `cdr`, `cons`, `list` |
| Arithmetic   | `+`, `-`, `*`, `/`, `quotient`, `remainder` |
| Control      | `if`, `cond`, `let`, `let*`, `begin`, `define`, `lambda` |
| I/O          | `read`, `display`, `newline`, `write` |
| Provide      | `provide`, `all-defined-out` |

**Forbidden:** `length`, `map`, `append`, `filter`, `for-each`, `assoc`, `member`,
`reverse`, `list-ref`, `list-tail`, `apply`, `call/cc`, `for/list`, `for/fold`

## How to Run and Test

```bash
# Load the solution file (grader mode — grader appends its own calls)
racket GROUP_ID_65/code/65_q4.rkt

# Run the test suite
racket GROUP_ID_65/tests/test_q4.rkt

# Quick inline test from stdin
echo "42 ((1 2) (3 4 5) (6) ()) 3" | racket -e '(require "GROUP_ID_65/code/65_q4.rkt") (print-insert-result)'
```

## Self-Review Checklist

Before committing any function, verify:

1. **Header** — file starts with `#lang racket/base`
2. **No top-level calls** — no bare expressions outside `define`; grader adds its own
3. **No forbidden built-ins** — grep the file: `grep -E '\b(length|map|append|filter|for-each)\b'` should return nothing
4. **Single definition** — `insert-if-short` appears exactly once (`grep -c 'define.*insert-if-short'` → 1)
5. **Length measured before insertion** — `my-length` is called on the original `lst`, before `my-map` processes it
6. **Empty list handling** — element check uses `(or (pair? elem) (null? elem))`, NOT just `pair?`
7. **Four given examples pass** — run test suite, check ex1–ex4 all PASS
8. **Performance** — `my-length` is tail-recursive; test with 10,000-element list
9. **print-insert-result reads in order** — `x` then `lst` then `n`; uses `display` + `newline`, no extra output

## Known AI Failure Modes for Racket

| Failure | Symptom | Fix |
|---|---|---|
| `pair?` vs `null?` confusion | Empty list `()` skipped during recursion | Use `(or (pair? elem) (null? elem))` |
| Using forbidden built-ins | `length`, `map` etc. sneak in | Grep after every generation |
| Top-level calls | File prints on load, breaking grader | Wrap everything in `define` |
| Measuring length after insertion | Wrong length used for decision | Bind `len` with `define` before `my-map` |
| Multiple definitions of same function | Grader sees last definition only, intermediate logic lost | Search for duplicate `define` names |
| `write` vs `display` | Strings/symbols get extra quotes | Use `display` for human-readable output |
