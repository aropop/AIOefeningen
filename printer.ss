#!r6rs

;;; Some functions to print.

(library
 (printer)
 (export print-node print-nodes print-path-to print-frontier)
 (import (rnrs base (6))
         (rnrs io simple (6))
         (prefix (ai node) node:)
         (prefix (ai frontier) frontier:))
 
 (define (print-node node)
   (assert (node:node? node))
   (display (node:state node))
   (display "(d:")
   (display (node:depth node))
   (display ")"))
 
 (define (print-nodes nodes)
   (assert (or (null? nodes) (list? nodes)))
   (cond [(null? nodes) (display "-empty-")]
         [else (print-node (car nodes))
               (for-each (lambda (node)
                           (display ", ")
                           (print-node node))
                         (cdr nodes))]))
 
 (define (print-path-to node)
   (assert (node:node? node))
   (display "path: ")
   (let ([path (node:path node)])
     (cond [(null? path) (display "-empty-")]
           [else (display (node:state (car path)))
                 (for-each (lambda (node)
                             (display ", ")
                             (display (node:state node)))
                           (cdr path))
                 (newline)
                 (display "depth: ")
                 (display (node:depth node))]))
   (newline))
 
 (define (print-frontier frontier)
   (assert (frontier:frontier? frontier))
   (print-nodes (frontier:nodes frontier)))
 )
