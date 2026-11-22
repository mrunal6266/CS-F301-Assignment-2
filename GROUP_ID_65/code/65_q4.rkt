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
;; SECTION 3: insert-if-short
;; Inserts atom x at the front of every list (at every level
;; of nesting) whose top-level length is strictly less than n.
;; Length is measured on the original list before any insertion.
;; (insert-if-short x lst n) -> list
;; ------------------------------------------------------------

; insert-if-short: atom list integer -> list
; Declarative reading: for every list at every level of nesting,
; if its top-level length (measured BEFORE insertion) is < n,
; prepend x to it. Atoms are left unchanged.
(define (insert-if-short x lst n)
  (define len (my-length lst))                  ; measure BEFORE any change
  (define processed                             ; recurse into sublists
    (my-map (lambda (elem)
              (if (pair? elem)
                  (insert-if-short x elem n)    ; elem is a sublist: recurse
                  elem))                        ; elem is an atom: leave it
            lst))
  (if (< len n)
      (cons x processed)                        ; length qualifies: prepend x
      processed))                               ; length does not qualify


;; ------------------------------------------------------------
;; SECTION 4: make-inserter
;; Higher-order function. Returns a function (of one list arg)
;; that inserts x at the front of every list whose length
;; satisfies the predicate len-ok?.
;; (make-inserter x len-ok?) -> (list -> list)
;; ------------------------------------------------------------

; TODO: implement make-inserter
; TODO: redefine insert-if-short using make-inserter (one final definition only)


;; ------------------------------------------------------------
;; SECTION 5: print-insert-result
;; Takes no arguments. Reads x, lst, n from stdin (using read),
;; calls insert-if-short, prints result with display + newline.
;; (print-insert-result) -> void
;; ------------------------------------------------------------

; TODO: implement print-insert-result
