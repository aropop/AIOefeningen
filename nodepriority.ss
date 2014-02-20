#!r6rs

;;; Set of functions which determine the priority of a node.

(library
 (nodepriority)
 (export depth)
 (import (rnrs base (6))
         (prefix (ai node) node:))
 
 (define (depth node)
   (assert (node:node? node))
   (node:depth node))
 
 )
