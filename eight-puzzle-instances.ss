#!r6rs

;;; Each instance is a state of an 8-puzzle. The elements in the list
;;; are ordered by going from left to right and top to bottom. For
;;; example, (list 0 1 2 3 4 5 6 7 8) =
;;; 0 1 2
;;; 3 4 5
;;; 6 7 8, and
;;; (list 0 1 4 3 5 2 6 7 8) = 
;;; 0 1 4
;;; 3 5 2
;;; 6 7 8.
;;; All instances are guaranteed to have a path to the goal state: 
;;; 0 1 2
;;; 3 4 5
;;; 6 7 8.

(library
 (eight-puzzle-instances)
 (export INSTANCES)
 (import (rnrs (6)))

 (define INSTANCES
   (list 
    (list 0 1 4 3 5 2 6 7 8)
    (list 0 1 6 7 5 3 4 8 2)
    (list 0 3 8 5 6 4 1 2 7)
    (list 0 4 2 5 7 6 8 3 1)
    (list 0 5 6 3 4 8 2 1 7)
    (list 0 6 7 4 3 5 8 2 1)
    (list 0 7 3 4 5 2 8 6 1)
    (list 0 8 1 2 3 4 6 5 7)
    (list 0 8 1 6 7 5 4 2 3)
    (list 0 8 7 5 6 1 4 3 2)
    (list 1 2 4 3 6 5 7 8 0)
    (list 1 2 4 6 3 8 7 5 0)
    (list 1 2 6 4 0 5 7 3 8)
    (list 1 3 2 7 0 4 5 6 8)
    (list 1 3 6 5 7 2 4 8 0)
    (list 1 7 0 2 5 8 4 6 3)
    (list 1 7 8 4 2 6 0 3 5)
    (list 2 1 5 6 0 4 3 7 8)
    (list 2 1 8 4 0 5 7 3 6)
    (list 2 4 8 3 0 5 6 7 1)
    (list 2 6 1 3 0 7 5 4 8)
    (list 2 6 5 7 0 4 3 1 8)
    (list 2 7 1 6 0 3 4 8 5)
    (list 2 8 0 4 3 5 7 6 1)
    (list 2 8 0 4 5 7 1 3 6)
    (list 3 2 5 7 0 6 4 8 1)
    (list 3 4 7 1 6 5 0 8 2)
    (list 3 5 0 6 2 1 7 4 8)
    (list 3 6 1 7 4 8 0 2 5)
    (list 3 8 1 5 2 7 4 6 0)
    (list 4 2 3 7 6 5 0 8 1)
    (list 4 2 5 1 7 3 0 6 8)
    (list 4 3 0 6 2 8 5 7 1)
    (list 4 5 1 8 6 3 7 2 0)
    (list 4 5 3 7 2 1 6 8 0)
    (list 4 5 7 6 0 8 1 2 3)
    (list 5 6 4 3 1 8 0 7 2)
    (list 6 3 5 4 0 8 7 2 1)
    (list 6 3 7 1 0 2 4 8 5)
    (list 6 4 2 5 0 8 7 1 3)
    (list 6 4 2 7 5 3 8 1 0)
    (list 6 4 3 2 8 1 5 7 0)
    (list 6 5 7 3 0 4 1 8 2)
    (list 6 7 3 5 0 2 4 8 1)
    (list 7 3 1 2 5 6 0 4 8)
    (list 7 3 4 6 0 2 8 1 5)
    (list 7 3 4 6 5 1 8 2 0)
    (list 8 4 5 2 3 1 0 7 6)
    (list 8 5 4 6 2 1 0 3 7)
    (list 8 7 5 6 1 4 3 2 0)))
)
