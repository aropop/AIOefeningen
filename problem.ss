#!r6rs

;;; Interface for any problem. The generic search algorithm relies on
;;; this interface.

(library
 (problem)
 (export new problem? initial step-cost is-goal? successors)
 (import (rnrs base (6)))
 
 (define (new initial step-cost is-goal? successors)
   (assert (procedure? initial))
   (assert (procedure? step-cost))
   (assert (procedure? is-goal?))
   (assert (procedure? successors))
   (make initial step-cost is-goal? successors))
 
 (define (problem? problem)
   (and (vector? problem)
        (symbol=? 'problem (vector-ref problem 0))))
 
 (define (initial problem)
   (assert (problem? problem))
   ((vector-ref problem 1)))
 
 (define (step-cost problem old-state action new-state)
   (assert (problem? problem))
   ((vector-ref problem 2) old-state action new-state))
 
 (define (is-goal? problem state)
   (assert (problem? problem))
   ((vector-ref problem 3) state))
 
 (define (successors problem state)
   (assert (problem? problem))
   ((vector-ref problem 4) state))
 
 ;;; private functions ----------------------------------------------------

 (define (make initial step-cost is-goal? successors)
   (vector 'problem initial step-cost is-goal? successors))
 )
