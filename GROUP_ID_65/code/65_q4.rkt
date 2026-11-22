#lang racket/base

;; ============================================================
;; CS F301 - Principles of Programming Languages
;; Assignment 2 | Group ID: 65
;; Problem S2: Conditionally Insert into a Nested List
;; File: 65_q4.rkt
;; ============================================================
;; Rules:
;;   - Only #lang racket/base built-ins are used.
;;   - No top-level calls; grader adds its own.
;;   - No output is printed when this file is loaded.
;; ============================================================


;; ------------------------------------------------------------
;; SECTION 1: my-length
;; Returns the number of top-level elements in a list.
;; (my-length lst) -> integer
;; ------------------------------------------------------------

; my-length: list -> integer
; Declarative reading: the length of an empty list is 0;
; the length of a non-empty list is 1 plus the length of its tail.
; Tail-recursive via an accumulator.
(define (my-length lst)
  (define (my-length-iter l acc)
    (if (null? l)
        acc
        (my-length-iter (cdr l) (+ acc 1))))
  (my-length-iter lst 0))


;; ------------------------------------------------------------
;; SECTION 2: my-map
;; Applies a function to each top-level element of a list.
;; (my-map f lst) -> list
;; ------------------------------------------------------------

; my-map: (a -> b) list -> list
; Declarative reading: mapping over an empty list gives an empty list;
; mapping over a non-empty list gives (f (car lst)) consed onto
; the result of mapping over the tail.
(define (my-map f lst)
  (if (null? lst)
      '()
      (cons (f (car lst))
            (my-map f (cdr lst)))))


;; ------------------------------------------------------------
;; SECTION 3 + 4: make-inserter and insert-if-short
;; make-inserter is a higher-order function: given atom x and
;; predicate len-ok?, it returns a function (inserter) that
;; inserts x at the front of every list (at every nesting level)
;; whose top-level length satisfies len-ok?.
;; insert-if-short is defined using make-inserter (one definition only).
;; (make-inserter x len-ok?) -> (list -> list)
;; (insert-if-short x lst n) -> list
;; ------------------------------------------------------------

; make-inserter: atom (integer -> boolean) -> (list -> list)
; Declarative reading: returns an inserter function that, given a list,
; measures its length (before any change), recursively processes each
; sublist element through the same inserter, and prepends x if
; (len-ok? len) holds.
(define (make-inserter x len-ok?)
  (define (inserter lst)
    (define len (my-length lst))             ; measure BEFORE any change
    (define processed                        ; recurse into sublists
      (my-map (lambda (elem)
                (if (or (pair? elem) (null? elem))
                    (inserter elem)          ; list (including empty): recurse
                    elem))                   ; atom: leave unchanged
              lst))
    (if (len-ok? len)
        (cons x processed)                   ; length satisfies predicate: prepend x
        processed))                          ; does not satisfy: return as-is
  inserter)

; insert-if-short: atom list integer -> list
; Defined using make-inserter with the predicate (< len n).
; This is the single, final definition of insert-if-short.
(define (insert-if-short x lst n)
  ((make-inserter x (lambda (len) (< len n))) lst))


;; ------------------------------------------------------------
;; SECTION 5: print-insert-result
;; Takes no arguments. Reads x, lst, n from stdin (using read),
;; calls insert-if-short, prints result with display + newline.
;; (print-insert-result) -> void
;; ------------------------------------------------------------

; print-insert-result: -> void
; Reads x, lst, n (in that order) from standard input using read.
; Calls (insert-if-short x lst n) and prints the result with display,
; followed by a newline. Prints no prompt or any other text.
(define (print-insert-result)
  (define x   (read))
  (define lst (read))
  (define n   (read))
  (display (insert-if-short x lst n))
  (newline))
