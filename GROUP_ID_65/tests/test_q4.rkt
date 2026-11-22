#lang racket/base

;; ============================================================
;; CS F301 - Assignment 2 | Group ID: 65
;; Test file for S2: insert-if-short and make-inserter
;; File: test_q4.rkt
;; ============================================================
;; Stand-alone: all definitions from 65_q4.rkt are copied here
;; so this file can be run with: racket tests/test_q4.rkt
;; Only built-ins listed in the assignment are used throughout.
;; ============================================================

;; ---- Definitions from 65_q4.rkt (copied verbatim) ----------

(define (my-length lst)
  (define (my-length-iter l acc)
    (if (null? l)
        acc
        (my-length-iter (cdr l) (+ acc 1))))
  (my-length-iter lst 0))

(define (my-map f lst)
  (if (null? lst)
      '()
      (cons (f (car lst))
            (my-map f (cdr lst)))))

(define (make-inserter x len-ok?)
  (define (inserter lst)
    (define len (my-length lst))
    (define processed
      (my-map (lambda (elem)
                (if (or (pair? elem) (null? elem))
                    (inserter elem)
                    elem))
              lst))
    (if (len-ok? len)
        (cons x processed)
        processed))
  inserter)

(define (insert-if-short x lst n)
  ((make-inserter x (lambda (len) (< len n))) lst))

(define (print-insert-result)
  (define x   (read))
  (define lst (read))
  (define n   (read))
  (display (insert-if-short x lst n))
  (newline))

;; ---- Minimal test harness (only allowed built-ins) ----------
;; Uses: display, newline, if, eq?, null?, cons, car, cdr, quote

(define (check label got expected)
  (if (equal? got expected)
      (begin (display "PASS  ") (display label) (newline))
      (begin (display "FAIL  ") (display label) (newline)
             (display "  expected: ") (display expected) (newline)
             (display "  got:      ") (display got)      (newline))))

;; ---- Assignment examples (all 4 must pass) ------------------

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

;; ---- Edge cases: n=0 (nothing ever inserted) ----------------

(check "n=0: flat list unchanged"
       (insert-if-short 'x '(1 2 3) 0)
       '(1 2 3))

(check "n=0: nested list unchanged"
       (insert-if-short 'x '((1) (2 3)) 0)
       '((1) (2 3)))

(check "n=0: empty list unchanged"
       (insert-if-short 'x '() 0)
       '())

;; ---- Edge cases: n=1 (only empty lists get insertion) -------

(check "n=1: empty sublist gets x, non-empty unchanged"
       (insert-if-short 'a '(1 (2 3) ()) 1)
       '(1 (2 3) (a)))

(check "n=1: empty top-level gets x"
       (insert-if-short 'a '() 1)
       '(a))

(check "n=1: nested empty lists all get x"
       (insert-if-short 'z '(() ()) 1)
       '((z) (z)))

;; ---- Edge case: deeply nested (6 levels) --------------------

(check "deep nesting 6 levels, n=2"
       (insert-if-short 'x '(a (b (c (d (e (f)))))) 2)
       '(a (b (c (d (e (x f)))))))

;; ---- Edge case: mixed atoms and sublists --------------------

(check "mixed: atoms unchanged, sublists processed"
       (insert-if-short 0 '(1 2 (3 4) 5 () 6) 3)
       '(1 2 (0 3 4) 5 (0) 6))

;; ---- Boundary: length == n vs length == n-1 -----------------

(check "length == n: no insertion (strict less-than)"
       (insert-if-short 'x '(1 2 3) 3)
       '(1 2 3))

(check "length == n-1: insertion happens"
       (insert-if-short 'x '(1 2) 3)
       '(x 1 2))

;; ---- make-inserter direct tests -----------------------------

(check "make-inserter: always-true predicate"
       ((make-inserter 'x (lambda (len) #t)) '(1 (2 3) ()))
       '(x 1 (x 2 3) (x)))

(check "make-inserter: always-false predicate"
       ((make-inserter 'x (lambda (len) #f)) '(1 (2 3) ()))
       '(1 (2 3) ()))

(check "make-inserter: even-length predicate"
       ((make-inserter 'e (lambda (len) (= (- len (* 2 (quotient len 2))) 0)))
        '(1 2 (3) (4 5)))
       '(e 1 2 (3) (e 4 5)))

;; ---- Performance: 10,000-element flat list ------------------
;; Build using only allowed built-ins (define, if, null?, cons, +, =, -)

(define (make-list-of n val)
  (define (iter i acc)
    (if (= i 0) acc (iter (- i 1) (cons val acc))))
  (iter n '()))

(define big-list (make-list-of 10000 1))

(check "perf: 10,000-element list n=10001 (prepends x)"
       (car (insert-if-short 'x big-list 10001))
       'x)

(check "perf: 10,000-element list n=10000 (no prepend)"
       (car (insert-if-short 'x big-list 10000))
       1)
