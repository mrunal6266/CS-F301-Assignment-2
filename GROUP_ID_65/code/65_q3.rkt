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

; print-all-traversals: inorder, preorder and postorder lists, one per line
(define (print-all-traversals tree)
  (display (inorder-acc tree '()))
  (newline)
  (display (preorder-acc tree '()))
  (newline)
  (display (postorder-acc tree '()))
  (newline))

; height of () = 0
; height of (v l r) = 1 + max(height l, height r)
(define (tree-height tree)
  (if (null? tree)
      0
      (+ 1 (max (tree-height (cadr tree)) (tree-height (caddr tree))))))

; leaves of () onto acc = acc
; leaves of a leaf (v () ()) onto acc = acc + 1
; leaves of (v l r) onto acc = leaves r onto (leaves l onto acc)
(define (count-leaves-acc tree acc)
  (cond ((null? tree) acc)
        ((and (null? (cadr tree)) (null? (caddr tree))) (+ acc 1))
        (else (count-leaves-acc (caddr tree)
                                (count-leaves-acc (cadr tree) acc)))))

; count-leaves: number of leaves in tree
(define (count-leaves tree)
  (count-leaves-acc tree 0))

; print-height-and-leaves: display (height leaf-count), then a newline
(define (print-height-and-leaves tree)
  (display (list (tree-height tree) (count-leaves tree)))
  (newline))
 

