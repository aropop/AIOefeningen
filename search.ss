#!r6rs

;;; The generic search algorithm.

(library
 (search)
 (export tree-search depth-first-tree-search)
 (import (rnrs base (6))
         (rnrs control (6))
         (prefix (ai node) node:)
         (prefix (ai problem) problem:)
         (prefix (ai frontier) frontier:))
 
 (define (tree-search problem openlist on-iteration-fn)
   (do ((current (node:initial-node problem)
                 (frontier:pop! openlist))
        (nof-nodes-handled 1 (+ 1 nof-nodes-handled)))
     ((or (not current)
          (problem:is-goal? problem (node:state current)))
      (on-iteration-fn nof-nodes-handled
                       current ; Can be #f !
                       openlist
                       '()
                       0)
      current)
     (let ([children (node:expand! current problem)])
       (on-iteration-fn nof-nodes-handled
                        current
                        openlist
                        children
                        0)
       (frontier:insert-all! openlist children))))

 (define (depth-first-tree-search problem on-iteration-fn)
   (tree-search problem (frontier:new-lifo) on-iteration-fn))
 )
