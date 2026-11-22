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

; TODO: implement my-length


;; ------------------------------------------------------------
;; SECTION 2: my-map
;; Applies a function to each top-level element of a list.
;; (my-map f lst) -> list
;; ------------------------------------------------------------

; TODO: implement my-map


;; ------------------------------------------------------------
;; SECTION 3: insert-if-short
;; Inserts atom x at the front of every list (at every level
;; of nesting) whose top-level length is strictly less than n.
;; Length is measured on the original list before any insertion.
;; (insert-if-short x lst n) -> list
;; ------------------------------------------------------------

; TODO: implement insert-if-short


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
