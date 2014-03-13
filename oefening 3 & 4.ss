#lang r6rs
(library
 (graph-state)
 (export new)
 (import (rnrs base (6))
         (rnrs control (6))
         (rnrs io simple)
         (only (racket vector) vector-copy)
         (ai printer)
         (prefix (ai node) node:)
         (prefix (ai problem) problem:)
         (prefix (ai frontier) frontier:)
         (prefix (ai successor) succ:)
         (ai graph)
         (prefix (ai search) search:))
 
 ;1
 ;S->G1 A->B->E->D 15
 ;S->G2 A->B->E->D 13
 ;S->G3 A->B 14
 
 ;2
 ;Depth first gaat infinite loopen over de lus S->A->C->S als je deze als eerst kiest, stel je kiest alfabetisch dan ga
 ; je naar G1 lopen
 
 ;3
 ;Breadth first gaat volgende lijst frontiers hebben na 4 stappen alleen de letters hebben want je kan in de G niet in exact 4 stappen komen
 ; je hebt hier geen eindstaten
 
 ;4
 ;Uniform
 
 ;5
 (define (run)
   (print-path-to (search:best-first-tree-search (new "weighted-directed-graph.txt" 'S '(G1 G2 G3))
                                                 (lambda (a b c d e) 
                                                   (display a) (newline)
                                                   (print-node b) (newline)
                                                   (print-frontier c) (newline)
                                                   (print-nodes d) (newline))
                                                 (lambda (node)
                                                   (/ 1 (node:cost node)))
                                                 )))
 
  
  (define (run-oefening4)
    (print-path-to (search:greedy-best-first-tree-search (new "weighted-directed-graph.txt" 'S '(G1 G2 G3))
                                                 (lambda (a b c d e) 
                                                   (display a) (newline)
                                                   (print-node b) (newline)
                                                   (print-frontier c) (newline)
                                                   (print-nodes d) (newline)))))
  
  (define (run-oefening4b)
    (print-path-to (search:A*-best-first-tree-search (new "weighted-directed-graph.txt" 'S '(G1 G2 G3))
                                                 (lambda (a b c d e) 
                                                   (display a) (newline)
                                                   (print-node b) (newline)
                                                   (print-frontier c) (newline)
                                                   (print-nodes d) (newline)))))
 
 
 )