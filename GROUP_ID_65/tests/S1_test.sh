#!/usr/bin/env bash
# Usage (from GROUP_ID_65/):  bash tests/S1_test.sh
# Copies code/65_q3.rkt to a temp file, appends calls, compares output.
set -u
SRC="$(dirname "$0")/../code/65_q3.rkt"
TMP="$(mktemp -d)"
fail=0

run_case () {  # $1 = name, $2 = calls, $3 = expected output
  cp "$SRC" "$TMP/t.rkt"
  printf '%s\n' "$2" >> "$TMP/t.rkt"
  actual="$(racket "$TMP/t.rkt" 2>&1)"
  if [ "$actual" == "$3" ]; then
    echo "PASS  $1"
  else
    echo "FAIL  $1"; echo "  expected:"; echo "$3" | sed 's/^/    /'
    echo "  actual:";   echo "$actual" | sed 's/^/    /'
    fail=1
  fi
}

DEFS="(define t1 '(4 (2 (1 () ()) (3 () ())) (6 (5 () ()) (7 () ()))))
(define t2 '(1 () (2 () (3 () ()))))
(define t3 '(a (b () ()) (c () ())))
(define single '(9 () ()))
(define left-chain '(3 (2 (1 () ()) ()) ()))
(define mixed '(x (1 () (y () ())) (z (2 () ()) ())))"

run_case "load prints nothing" "" ""

run_case "t1 inorder" "$DEFS
(print-inorder t1)" "(1 2 3 4 5 6 7)"

run_case "t1 all traversals" "$DEFS
(print-all-traversals t1)" "(1 2 3 4 5 6 7)
(4 2 1 3 6 5 7)
(1 3 2 5 7 6 4)"

run_case "t1 height/leaves" "$DEFS
(print-height-and-leaves t1)" "(3 4)"

run_case "t2 all traversals" "$DEFS
(print-all-traversals t2)" "(1 2 3)
(1 2 3)
(3 2 1)"

run_case "t2 height/leaves" "$DEFS
(print-height-and-leaves t2)" "(3 1)"

run_case "t3 all traversals" "$DEFS
(print-all-traversals t3)" "(b a c)
(a b c)
(b c a)"

run_case "t3 height/leaves" "$DEFS
(print-height-and-leaves t3)" "(2 2)"

run_case "empty inorder" "(print-inorder '())" "()"

run_case "empty all traversals" "(print-all-traversals '())" "()
()
()"

run_case "empty height/leaves" "(print-height-and-leaves '())" "(0 0)"

run_case "single node" "$DEFS
(print-all-traversals single)
(print-height-and-leaves single)" "(9)
(9)
(9)
(1 1)"

run_case "left-only chain" "$DEFS
(print-all-traversals left-chain)
(print-height-and-leaves left-chain)" "(1 2 3)
(3 2 1)
(1 2 3)
(3 1)"

run_case "mixed numbers and symbols" "$DEFS
(print-all-traversals mixed)
(print-height-and-leaves mixed)" "(1 y x 2 z)
(x 1 y z 2)
(y 1 2 z x)
(3 2)"

rm -rf "$TMP"
[ $fail -eq 0 ] && echo "All S1 tests passed." || { echo "Some S1 tests FAILED."; exit 1; }
