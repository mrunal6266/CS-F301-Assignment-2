#lang racket/base

;; ============================================================
;; CS F301 - Assignment 2 | Group ID: 65
;; Test file for S1: print-inorder, print-all-traversals,
;;                   print-height-and-leaves
;; File: test_q3.rkt
;; Run from anywhere:  racket tests/test_q3.rkt
;; ============================================================

(require racket/port racket/runtime-path)

;; 65_q3.rkt has no (provide ...) (not an allowed built-in), so we
;; load the module and evaluate calls inside its own namespace.
(define-runtime-path code-file "../code/65_q3.rkt")
(dynamic-require code-file #f)
(define code-ns (module->namespace code-file))

;; Run a quoted expression inside the solution module and capture
;; everything it prints.
(define (output-of expr)
  (with-output-to-string
    (lambda () (eval expr code-ns))))

;; ------------------------------------------------------------
;; Test harness
;; ------------------------------------------------------------

(define pass-count 0)
(define fail-count 0)

(define (check label got expected)
  (if (equal? got expected)
      (begin
        (set! pass-count (+ pass-count 1))
        (display (string-append "PASS  " label))
        (newline))
      (begin
        (set! fail-count (+ fail-count 1))
        (display (string-append "FAIL  " label))
        (newline)
        (display "  expected: ") (write expected) (newline)
        (display "  got:      ") (write got)      (newline))))

;; ------------------------------------------------------------
;; Trees
;; ------------------------------------------------------------

(define t1 '(4 (2 (1 () ()) (3 () ())) (6 (5 () ()) (7 () ()))))
(define t2 '(1 () (2 () (3 () ()))))
(define t3 '(a (b () ()) (c () ())))
(define single '(9 () ()))
(define left-chain '(3 (2 (1 () ()) ()) ()))
(define mixed '(x (1 () (y () ())) (z (2 () ()) ())))

;; ------------------------------------------------------------
;; Loading the file must print nothing
;; ------------------------------------------------------------

(check "loading 65_q3.rkt prints nothing"
       (with-output-to-string
         (lambda ()
           (parameterize ([current-namespace (make-base-namespace)])
             (dynamic-require code-file #f))))
       "")

;; ------------------------------------------------------------
;; Assignment examples (must all pass)
;; ------------------------------------------------------------

(check "t1 print-inorder"
       (output-of `(print-inorder ',t1))
       "(1 2 3 4 5 6 7)\n")

(check "t1 print-all-traversals"
       (output-of `(print-all-traversals ',t1))
       "(1 2 3 4 5 6 7)\n(4 2 1 3 6 5 7)\n(1 3 2 5 7 6 4)\n")

(check "t1 print-height-and-leaves"
       (output-of `(print-height-and-leaves ',t1))
       "(3 4)\n")

(check "t2 print-all-traversals"
       (output-of `(print-all-traversals ',t2))
       "(1 2 3)\n(1 2 3)\n(3 2 1)\n")

(check "t2 print-height-and-leaves"
       (output-of `(print-height-and-leaves ',t2))
       "(3 1)\n")

(check "t3 print-all-traversals"
       (output-of `(print-all-traversals ',t3))
       "(b a c)\n(a b c)\n(b c a)\n")

(check "t3 print-height-and-leaves"
       (output-of `(print-height-and-leaves ',t3))
       "(2 2)\n")

(check "empty print-inorder"
       (output-of '(print-inorder '()))
       "()\n")

(check "empty print-all-traversals"
       (output-of '(print-all-traversals '()))
       "()\n()\n()\n")

(check "empty print-height-and-leaves"
       (output-of '(print-height-and-leaves '()))
       "(0 0)\n")

;; ------------------------------------------------------------
;; Edge cases
;; ------------------------------------------------------------

(check "single node: all traversals"
       (output-of `(print-all-traversals ',single))
       "(9)\n(9)\n(9)\n")

(check "single node: height 1, 1 leaf"
       (output-of `(print-height-and-leaves ',single))
       "(1 1)\n")

(check "left-only chain: all traversals"
       (output-of `(print-all-traversals ',left-chain))
       "(1 2 3)\n(3 2 1)\n(1 2 3)\n")

(check "left-only chain: height/leaves"
       (output-of `(print-height-and-leaves ',left-chain))
       "(3 1)\n")

(check "mixed numbers and symbols: all traversals"
       (output-of `(print-all-traversals ',mixed))
       "(1 y x 2 z)\n(x 1 y z 2)\n(y 1 2 z x)\n")

(check "mixed numbers and symbols: height/leaves"
       (output-of `(print-height-and-leaves ',mixed))
       "(3 2)\n")

;; ------------------------------------------------------------
;; Deep trees: 10,000-node chains (no stack overflow)
;; ------------------------------------------------------------

;; Right chain (1 () (2 () (... (10000 () ())))), built tail-recursively
(define (make-right n acc)
  (if (= n 0) acc (make-right (- n 1) (list n '() acc))))

;; Left chain (10000 (9999 (... (1 () ()) ...) ()) ()), built tail-recursively
(define (make-left k n acc)
  (if (> k n) acc (make-left (+ k 1) n (list k acc '()))))

(define deep-right (make-right 10000 '()))
(define deep-left (make-left 1 10000 '()))

;; Expected inorder output "(1 2 ... 10000)\n"
(define (numbers-string k n)
  (if (= k n)
      (number->string n)
      (string-append (number->string k) " " (numbers-string (+ k 1) n))))
(define expected-seq (string-append "(" (numbers-string 1 10000) ")\n"))

(check "deep right chain inorder (10000)"
       (output-of `(print-inorder ',deep-right))
       expected-seq)

(check "deep left chain inorder (10000)"
       (output-of `(print-inorder ',deep-left))
       expected-seq)

(check "deep right chain height/leaves"
       (output-of `(print-height-and-leaves ',deep-right))
       "(10000 1)\n")

(check "deep left chain height/leaves"
       (output-of `(print-height-and-leaves ',deep-left))
       "(10000 1)\n")

;; ------------------------------------------------------------
;; Summary
;; ------------------------------------------------------------

(newline)
(display (string-append "Results: "
                        (number->string pass-count) " passed, "
                        (number->string fail-count) " failed"))
(newline)
