#!r6rs

;;; Implemention of a frontier, also called fringe or open list. It holds
;;; the nodes of a search tree which are still to be expanded. It has 3 
;;; implementations: a FIFO (or queue) which adds new nodes to the back, a
;;; LIFO (or stack) which adds new nodes to the front, and a priority based
;;; one which requires a priority function and add nodes according to
;;; priority. 

(library
 (frontier)
 (export new-fifo new-lifo new frontier? nodes empty? insert! insert-all! pop!)
 (import (rnrs base (6))
         (data heap)
         (data queue)
         (only (racket mpair) list->mlist))
 
 ;; Return a new FIFO frontier.
 (define (new-fifo)
   (make fifo-frontier? fifo-nodes fifo-size fifo-empty?
         fifo-insert! fifo-insert-all! fifo-pop!
         (make-queue)))
 
 ;; Return a new LIFO frontier.
 (define (new-lifo)
   (make lifo-frontier? lifo-nodes lifo-size lifo-empty?
         lifo-insert! lifo-insert-all! lifo-pop!
         '()))
 
 ;; Return a new priority based frontier. The function PRIORITY-FN takes an
 ;; element of the frontier and returns its priority (bigger number is 
 ;; higher priority).
 (define (new priority-fn)
   (assert (procedure? priority-fn))
   (make pq-frontier? pq-nodes pq-size pq-empty?
         pq-insert! pq-insert-all! pq-pop!
         (make-heap (lambda (node1 node2)
                      (>= (priority-fn node1)
                          (priority-fn node2))))))
 
 ;; Return true if FRONTIER is a frontier, false otherwise.
 (define (frontier? frontier)
   (and (vector? frontier)
        (symbol=? 'frontier2 (vector-ref frontier 0))
        ((vector-ref frontier 1) (data frontier))))
 
 ;; Return all nodes in the FRONTIER as a list. The order is unspecified.
 (define (nodes frontier)
   (frontier? frontier)
   ((vector-ref frontier 2) (data frontier)))
 
 ;; Return the number of elements in FRONTIER.
 (define (size frontier)
   (frontier? frontier)
   ((vector-ref frontier 3) (data frontier)))
 
 ;; Return true if FRONTIER empty, false otherwise.
 (define (empty? frontier)
   (frontier? frontier)
   ((vector-ref frontier 4) (data frontier)))
 
 ;; Insert NODE in FRONTIER.
 (define (insert! frontier node)
   (frontier? frontier)
   ; Pass entire frontier, not just the datastructure, since the stack
   ;   implementation is non-destructive.
   ((vector-ref frontier 5) frontier node))
 
 ;; Insert all NODES in FRONTIER. If all else is equal, the order of the
 ;; elements is respected.
 (define (insert-all! frontier nodes)
   (frontier? frontier)
   (list? nodes)
   ((vector-ref frontier 6) frontier nodes))
 
 ;; Return and remove the first element of FRONTIER.
 (define (pop! frontier)
   (frontier? frontier)
   ((vector-ref frontier 7) frontier)) 
 
 ;;; private functions ----------------------------------------------------

 (define (make frontier?-fn nodes-fn size-fn empty?-fn
               insert!-fn insert-all!-fn pop!-fn
               data)
   (vector 'frontier2 frontier?-fn nodes-fn size-fn empty?-fn
           insert!-fn insert-all!-fn pop!-fn
           data))
 
 (define (data frontier)
   (vector-ref frontier 8))
 
 (define (data! frontier new-data)
   (vector-set! frontier 8 new-data))
 
 ;;; queue functions
 (define (fifo-frontier? queue)
   (queue? queue))
 (define (fifo-nodes queue)
   ;; Racket's list is immutable, R6RS's list is mutable, hence the 
   ;; conversion.
   (list->mlist (queue->list queue)))
 (define (fifo-size queue)
   (queue-length queue))
 (define (fifo-empty? queue)
   (queue-empty? queue))
 (define (fifo-insert! frontier node)
   (enqueue! (data frontier) node))
 (define (fifo-insert-all! frontier nodes)
   (for-each (lambda (node)
               (enqueue! (data frontier) node))
             nodes))
 (define (fifo-pop! frontier)
   (dequeue! (data frontier)))
 
 ;;; stack functions, the stack itself is not desctructive!
 (define (lifo-frontier? stack)
   (list? stack))
 (define (lifo-nodes stack)
   stack)
 (define (lifo-size stack)
   (length stack))
 (define (lifo-empty? stack)
   (null? stack))
 (define (lifo-insert! frontier node)
   (data! frontier (cons node (data frontier))))
 (define (lifo-insert-all! frontier nodes)
   (data! frontier (append nodes (data frontier))))
 (define (lifo-pop! frontier)
   (if (null? (data frontier)) 
       #f
       (let ([ret (car (data frontier))])
         (data! frontier (cdr (data frontier)))
         ret)))
 
 ;;; priority-queue functions
 (define (pq-frontier? heap)
   (heap? heap))
 (define (pq-nodes heap)
   (vector->list (heap->vector heap)))
 (define (pq-size heap)
   (heap-count heap))
 (define (pq-empty? heap)
   (= 0 (heap-count heap)))
 (define (pq-insert! frontier node)
   (heap-add! (data frontier) node))
 (define (pq-insert-all! frontier nodes)
   (for-each (lambda (node)
               (heap-add! (data frontier) node))
             nodes))
 (define (pq-pop! frontier)
   (let ([node (heap-min (data frontier))])
     (heap-remove-min! (data frontier))
     node))
 )
