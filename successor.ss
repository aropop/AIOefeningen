#!r6rs

;;; Implementation of a state-action pair.

(library
 (successor)
 (export new successor? state action)
 (import (rnrs base (6)))
 
 (define (new state action)
   (make state action))
 
 (define (successor? successor)
   (and (vector? successor)
        (symbol=? 'successor (vector-ref successor 0))))
 
 (define (state successor)
   (assert (successor? successor))
   (vector-ref successor 1))
 
 (define (action successor)
   (assert (successor? successor))
   (vector-ref successor 2))
 
 ;;; private functions ----------------------------------------------------
 
 (define (make state action)
   (vector 'successor state action))
 )
