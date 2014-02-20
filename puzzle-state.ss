#lang r6rs


(library
 (puzzle-state)
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
         (prefix (ai search) search:))
 
 
 (define (new)
   (vector 'x 'x '- 'o 'o))
 
 (define (swap state i1 i2)
   (define new (vector-copy state))
   (define temp (vector-ref new i2))
   (vector-set! new i2 (vector-ref new i1))
   (vector-set! new i1 temp)
   new)
 
 (define (move state index amount)
   (define direction 'right)
   (define symbol (vector-ref state index))
   (define porm (if (eq? symbol 'o) - +))
   (if (eq? symbol 'o)
       (set! direction 'left))
   
   (cond  ((eq? symbol '-)
           #f)
          ((or (>= (porm index amount) (vector-length state)) (< (porm index amount) 0)) #f)
          (else (cond ((> amount 2) #f)
                      (else
                       (let ((target (if (eq? direction 'left)
                                         (vector-ref state (- index amount))
                                         (vector-ref state (+ index amount)))))
                         (cond ((not (eq? target '-)) #f)
                               ((and
                                 (= amount 2)
                                 (not (eq? (vector-ref state 
                                                       (if (eq? direction 'left) 
                                                           (porm index 1) 
                                                           (porm index 1))) 
                                           (if (eq? symbol 'o) 'x 'o))))
                                #f)
                               (else 
                                (swap state index (if (eq? direction 'left) 
                                                      (- index amount) 
                                                      (+ index amount)))))))))))
 
 
 
 ;Vereiste voor het zoek algoritme
 (define (initial) (new))
 
 (define (is-goal? state)
   (equal? state (vector 'o 'o '- 'x 'x)))
 
 (define (step-cost a b c) 1)
 
 (define (succesors state)
   (let loop
     ((ctr 0)
      (res '()))
     (if (= ctr (vector-length state))
         res
         (let ((m1 (move state ctr 1))
               (m2 (move state ctr 2)))
           (if m1
               (set! res (cons (succ:new m1 #f) res)))
           (if m2
               (set! res (cons (succ:new m2 #f) res)))
           (loop (+ ctr 1) res)))))
 
 
 
 (define puzzle (problem:new initial step-cost is-goal? succesors))
 
 (define (r)
   (print-path-to (search:depth-first-tree-search puzzle (lambda (a b c d e) 
                                            (display a) (newline)
                                            (print-node b) (newline)
                                            (print-frontier c) (newline)
                                            (print-nodes d) (newline)))))
 
 
 
 
 )