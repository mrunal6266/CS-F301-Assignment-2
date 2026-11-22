#lang racket/base

;; ============================================================
;; CS F301 - Assignment 2 | Group ID: 65
;; Test file for S2: insert-if-short and make-inserter
;; File: test_q4.rkt
;; ============================================================

(require "../code/65_q4.rkt")

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
        (display "  expected: ") (display expected) (newline)
        (display "  got:      ") (display got)      (newline))))

;; ------------------------------------------------------------
;; Assignment examples (must all pass)
;; ------------------------------------------------------------

(check "ex1: 42 ((1 2)(3 4 5)(6)()) n=3"
       (insert-if-short 42 '((1 2) (3 4 5) (6) ()) 3)
       '((42 1 2) (3 4 5) (42 6) (42)))

(check "ex2: 0 (((1) 2)(3)((4 5 6)())) n=3"
       (insert-if-short 0 '(((1) 2) (3) ((4 5 6) ())) 3)
       '((0 (0 1) 2) (0 3) (0 (4 5 6) (0))))

(check "ex3: 7 () n=3  -> (7)"
       (insert-if-short 7 '() 3)
       '(7))

(check "ex4: 7 () n=0  -> ()"
       (insert-if-short 7 '() 0)
       '())

;; ------------------------------------------------------------
;; Edge cases: n=0 (nothing ever inserted)
;; ------------------------------------------------------------

(check "n=0: flat list unchanged"
       (insert-if-short 'x '(1 2 3) 0)
       '(1 2 3))

(check "n=0: nested list unchanged"
       (insert-if-short 'x '((1) (2 3)) 0)
       '((1) (2 3)))

(check "n=0: empty list unchanged"
       (insert-if-short 'x '() 0)
       '())

;; ------------------------------------------------------------
;; Edge cases: n=1 (only empty lists get insertion)
;; ------------------------------------------------------------

(check "n=1: empty sublist gets x, non-empty unchanged"
       (insert-if-short 'a '(1 (2 3) ()) 1)
       '(1 (2 3) (a)))

(check "n=1: empty top-level gets x"
       (insert-if-short 'a '() 1)
       '(a))

(check "n=1: nested empty lists all get x"
       (insert-if-short 'z '(() ()) 1)
       '(() (z) (z)))

;; ------------------------------------------------------------
;; Edge case: deeply nested list (6 levels)
;; ------------------------------------------------------------

;; (a (b (c (d (e (f)))))) with n=2
;; Each sublist has 1 element (< 2), so x is prepended at every level
(check "deep nesting 6 levels, n=2"
       (insert-if-short 'x '(a (b (c (d (e (f)))))) 2)
       '(x a (x b (x c (x d (x e (x f)))))))

;; ------------------------------------------------------------
;; Edge case: mixed atoms and sublists
;; ------------------------------------------------------------

(check "mixed: atoms unchanged, sublists processed"
       (insert-if-short 0 '(1 2 (3 4) 5 () 6) 3)
       '(1 2 (0 3 4) 5 (0) 6))

;; ------------------------------------------------------------
;; Edge case: list of exactly n elements (not inserted)
;; ------------------------------------------------------------

(check "length == n: no insertion (strict less-than)"
       (insert-if-short 'x '(1 2 3) 3)
       '(1 2 3))

(check "length == n-1: insertion happens"
       (insert-if-short 'x '(1 2) 3)
       '(x 1 2))

;; ------------------------------------------------------------
;; make-inserter: direct tests
;; ------------------------------------------------------------

(check "make-inserter with always-true predicate"
       ((make-inserter 'x (lambda (len) #t)) '(1 (2 3) ()))
       '(x 1 (x 2 3) (x)))

(check "make-inserter with always-false predicate"
       ((make-inserter 'x (lambda (len) #f)) '(1 (2 3) ()))
       '(1 (2 3) ()))

(check "make-inserter with even-length predicate"
       ((make-inserter 'e (lambda (len) (= (remainder len 2) 0))) '(1 2 (3) (4 5)))
       '(e 1 2 (3) (e 4 5)))

;; ------------------------------------------------------------
;; Performance: large flat list of 10,000 elements, n=10001
;; (every element should get x prepended at top level only;
;;  no stack overflow)
;; ------------------------------------------------------------

;; Build a list of 10,000 atoms using tail recursion
(define (make-list-of n val)
  (define (iter i acc)
    (if (= i 0)
        acc
        (iter (- i 1) (cons val acc))))
  (iter n '()))

(define big-list (make-list-of 10000 1))

;; With n=10001, top-level len=10000 < 10001, so x is prepended
(check "perf: 10,000-element list, n=10001 (prepends x)"
       (car (insert-if-short 'x big-list 10001))
       'x)

;; With n=10000, top-level len=10000 is NOT < 10000, so no prepend
(check "perf: 10,000-element list, n=10000 (no prepend)"
       (car (insert-if-short 'x big-list 10000))
       1)

;; ------------------------------------------------------------
;; Summary
;; ------------------------------------------------------------

(newline)
(display (string-append "Results: "
                        (number->string pass-count) " passed, "
                        (number->string fail-count) " failed"))
(newline)
