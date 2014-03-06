#!r6rs

;;; Implementation of a node in a search tree. The most important
;;; elements of a node are: a parent node and a state.

;;; Update 2012-02-25
;;;     - Added function INITIAL-NODE to create initial node of the
;;;       search problem.
;;; Update 2012-02-27
;;;     - Do no longer keep track of the children of a node.
;;; Update 2013-03-07
;;;     - Export accessor ACTION, but no longer export constructor
;;;       NEW.

(library
 (node)
 (export node? initial-node parent state action depth expand! path cost)
 (import (rnrs base (6))
         (prefix (ai problem) problem:)
         (prefix (ai successor) successor:))
 
 (define (node? node)
   (and (vector? node)
        (symbol=? 'node (vector-ref node 0))))
 
 ;; Creates a new node, the root node of the search tree which refers
 ;; to the initial state of the problem and has no parent, nor action.
 (define (initial-node problem)
   (assert (problem:problem? problem))
   (let ([state (problem:initial problem)])
     (new #f state #f 0)))
 
 (define (parent node)
   (assert (node? node))
   (vector-ref node 1))
 
 (define (state node)
   (assert (node? node))
   (vector-ref node 2))
 
 (define (action node)
   (assert (node? node))
   (vector-ref node 3))
 
 (define (depth node)
   (assert (node? node))
   (vector-ref node 4))
 
 (define (cost node)
   (assert (node? node))
   (vector-ref node 6))
 
 ;; Expands the node according to the given problem implementation. 
 ;; The new nodes are (added to this node and) returned.
 (define (expand! node problem)
   (assert (node? node))
   (assert (problem:problem? problem))
   (let* ([old-state (state node)]
          [successors (problem:successors problem old-state)]
          [children 
           (map (lambda (successor)
                  (let* ([new-state (successor:state successor)]
                        [action (successor:action successor)]
                        [cost (+ (cost node) (problem:step-cost problem old-state action new-state))])
                    (new node
                         new-state
                         action
                         cost)))
                successors)])
     ; The search itself does not require us to keep track of the 
     ;   children of a node. It is necessary to keep track of the 
     ;   children if, for example, you'd want to see the search tree.
     ;(children! node children)
     children))
 
 ;; Returns a path from the root node to this node as a list of nodes.
 (define (path node)
   (assert (node? node))
   (if (parent node)
       (append (path (parent node)) (list node))
       (list node)))
 
 ;;; private functions ----------------------------------------------------

 ;; Creates a new node with no children.
 ;; Parameters:
 ;; - parent, node: the parent node or #f in case this is the root 
 ;;     node of the search tree.
 ;; - new-state, any: each node refers to a specific state in the search
 ;;     space, which is problem specific.
 ;; - action, any: the action used to reach the state of this node.
 (define (new parent new-state action cost)
   (assert (or (not parent) (node? parent)))
   (make parent new-state action
         (if parent (+ 1 (depth parent)) 0)
         '()
         cost))
 
 (define (make parent state action depth children cost)
   (vector 'node parent state action depth children cost))
 
 (define (children! node children)
   (assert (node? node))
   (assert (list? children))
   (vector-set! node 5 children))
 )
