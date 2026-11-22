#lang racket/base

; S1: Binary Tree Traversals
; A tree is either () or a three-element list (value left right).

; inorder of () = acc
; inorder of (v l r) onto acc = inorder l onto (v . inorder r onto acc)
; The right subtree is folded into acc first, so the list is built from the
; right end and comes out in the correct order without append or reverse.
(define (inorder-acc tree acc)
  (if (null? tree)
      acc
      (inorder-acc (cadr tree)
                   (cons (car tree) (inorder-acc (caddr tree) acc)))))

; print-inorder: display the inorder list of tree, then a newline
(define (print-inorder tree)
  (display (inorder-acc tree '()))
  (newline))

; preorder of () = acc
; preorder of (v l r) onto acc = v . (preorder l onto (preorder r onto acc))
(define (preorder-acc tree acc)
  (if (null? tree)
      acc
      (cons (car tree)
            (preorder-acc (cadr tree) (preorder-acc (caddr tree) acc)))))
; postorder of () = acc
; postorder of (v l r) onto acc = postorder l onto (postorder r onto (v . acc))
(define (postorder-acc tree acc)
  (if (null? tree)
      acc
      (postorder-acc (cadr tree)
                     (postorder-acc (caddr tree) (cons (car tree) acc)))))

