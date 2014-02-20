#!r6rs

;;; Implemention of a search problem, by reading a graph description 
;;; from a text file. I admit, this code is not particularly nice. You
;;; should only care about function <new>.

;;; Update 2012-02-25
;;;     - removed unnecessary display on line 147.

(library
 (graph)
 (export new)
 (import (rnrs base (6))
         (rnrs control (6))
         (rnrs lists (6))
         (rnrs io simple (6))
         (rnrs files (6))
         (prefix (ai node) node:)
         (prefix (ai problem) problem:)
         (prefix (ai successor) successor:)
         (ai utils))
 
 ;; Create a graph as a search problem.
 ;; Returns: a problem (see problem.ss for its interface).
 ;; Parameters:
 ;; - filename, string: filename of the file containing the graph's 
 ;;     description
 ;; - start, symbol: one of the states of the graph used as initial
 ;;     state for the search
 ;; - goals, list of symbols: list of states of the graph that satisfy
 ;;     the goal-test
 (define (new filename start goals)
   (assert (string? filename))
   (assert (valid-state? start))
   (assert (list? goals))
   (let ([graph (file->graph filename)])
     (let ([initial 
            (lambda () start)]
           [step-cost
            (lambda (state action new-state)
              (vertex-cost (graph-vertex graph state)
                           new-state))]
           [heuristic
            (lambda (state)
              (vertex-heuristic (graph-vertex graph state)))]
           [is-goal?
            (lambda (state)
              (find (lambda (goal)
                      (same-state? state goal))
                    goals))]
           [successors
            (lambda (state)
              (map (lambda (edge)
                     (successor:new (car edge)
                                    (car edge)))
                   (vertex-edges (graph-vertex graph state))))])
       (problem:new initial
                    step-cost
                    heuristic
                    is-goal?
                    successors))))
 
 ;;; private functions ----------------------------------------------------
 
 ;-- STATE
 ; States are represented by symbols.
 (define (valid-state? state)
   (symbol? state))
 (define (same-state? state1 state2)
   (symbol=? state1 state2))
 
 ;-- VERTEX 
 ; A vertex has a heuristic (real number) and a association list of 
 ; edges. The key is a state to which the edge leads, the value the 
 ; edge cost (real number). 
 (define (make-vertex heuristic)
   (vector 'vertex heuristic '()))
 (define (vertex? vertex)
   (and (vector? vertex)
        (symbol=? 'vertex (vector-ref vertex 0))))
 (define (vertex-heuristic vertex)
   (assert (vertex? vertex))
   (vector-ref vertex 1))
 (define (vertex-edges vertex)
   (assert (vertex? vertex))
   (vector-ref vertex 2))
 (define (vertex-add-edge! vertex to-state cost)
   ; List of edges remains in the order as they are added.
   (assert (vertex? vertex))
   (assert (valid-state? to-state))
   (assert (number? cost))
   (vector-set! vertex 2 
                (append (vertex-edges vertex)
                        (list (cons to-state cost)))))
 (define (vertex-cost vertex to-state)
   (assert (vertex? vertex))
   (assert (valid-state? to-state))
   (cdr (assoc to-state (vertex-edges vertex))))
 
 ;-- GRAPH
 ; A graph has an association list of vertices. The key is a state and
 ; the value is a vertex object.
 (define (make-graph)
   (vector 'graph '()))
 (define (graph? graph)
   (and (vector? graph)
        (symbol=? 'graph (vector-ref graph 0))))
 (define (graph-vertices graph)
   (assert (graph? graph))
   (vector-ref graph 1))
 (define (graph-vertices! graph vertices)
   (assert (graph? graph))
   (assert (list? vertices))
   (vector-set! graph 1 vertices))
 (define (graph-vertex graph state)
   (assert (graph? graph))
   (assert (valid-state? state))
   (cdr (assoc state (graph-vertices graph))))
 (define (graph-add-vertex! graph state heuristic)
   (assert (graph? graph))
   (assert (valid-state? state))
   (assert (number? heuristic))
   (let ([vertex (make-vertex heuristic)])
     (vector-set! graph 1
                  (cons (cons state vertex)
                        (graph-vertices graph)))))
 (define (graph-add-edge! graph from-state to-state cost)
   (assert (graph? graph))
   (assert (valid-state? from-state))
   (assert (valid-state? to-state))
   (assert (number? cost))
   (vertex-add-edge! (graph-vertex graph from-state) to-state cost))
 (define (file->graph filename)
   (assert (file-exists? filename))
   (let* ([graph (make-graph)]
          [input (open-input-file filename)]
          [states (read-csv-line input)]
          [heuristics (read-csv-line input)])
     ; Add vertices by label and heuristic.
     (for-each (lambda (state heuristic)
                 (graph-add-vertex! graph 
                                    (string->symbol state)
                                    (string->number heuristic)))
               states heuristics)
     ; Add edges if no cost is given, use 1.0
     (do ((fields (read-csv-line input)
                  (read-csv-line input)))
       ((or (not fields) (< (length fields) 2))
        (close-input-port input) graph)
       (let ([from-state (string->symbol (car fields))]
             [to-state (string->symbol (cadr fields))]
             [cost (if (= (length fields) 3)
                       (string->number (caddr fields))
                       1.0)])
         (graph-add-edge! graph from-state to-state cost)))))
 )
