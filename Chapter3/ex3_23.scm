;; Exercise 3.23
;; implementation of deque

;; Method 1
;;
(define (front-ptr deque) (car deque))
(define (rear-ptr deque) (cdr deque))
(define (set-front-ptr! deque item) (set-car! deque item))
(define (set-rear-ptr! deque item) (set-cdr! deque item))

(define (make-deque) (cons '() '()))
(define (empty-deque? deque)
  (or (null? (front-ptr deque)) (null? (rear-ptr deque))))
(define (front-deque deque)
  (if (empty-deque? deque)
      (error "FRONT callled with an empty deque")
      (car (front-ptr deque))))
(define (rear-deque deque)
  (if (empty-deque? deque)
      (error "REAR called with an empty deque")
      (car (rear-ptr deque))))
(define (front-insert-deque! deque item)
  (let ((new-pair (cons item '())))
    (cond ((empty-deque? deque)
           (set-front-ptr! deque new-pair)
           (set-rear-ptr! deque new-pair)
           deque)
          (else
           (set-cdr! new-pair (front-ptr deque))
           (set-front-ptr! deque new-pair)
           deque))))
(define (rear-insert-deque! deque item)
  (let ((new-pair (cons item '())))
    (cond ((empty-deque? deque)
           (set-front-ptr! deque new-pair)
           (set-rear-ptr! deque new-pair)
           deque)
          (else
           (set-cdr! (rear-ptr deque) new-pair)
           (set-rear-ptr! deque new-pair)
           deque))))
(define (front-delete-deque! deque)
  (cond ((empty-deque? deque)
         (error "DELETE! called with an empty deque"))
        (else
         (set-front-ptr! deque (cdr (front-ptr deque)))
         deque)))
;; this implementation of rear-delete-deque! is O(n)
(define (rear-delete-deque! deque)
  (define (iter front)
    (cond ((eq? (cdr front) (rear-ptr deque))
           (set-cdr! front '())
           (set-rear-ptr! deque front)
           deque)
          (else
           (iter (cdr front)))))
  (cond ((empty-deque? deque)
         (error "DELETE! called with an empty deque"))
        ((eq? (front-ptr deque) (rear-ptr deque))
         (set-front-ptr! deque '())
         (set-rear-ptr! deque '())
         deque)
        (else
         (iter (front-ptr deque)))))
(define (print-deque queue)
  (let ((front (front-ptr queue))
        (rear (rear-ptr queue)))
    (define (iter front rear)
      (cond ((eq? front rear)
             (display (car front)))
            (else
             (display (car front))
             (display "-")
             (iter (cdr front) rear))))
    (if (empty-deque? queue)
        (display "Empty queue")
        (iter front rear))))

;; test
(define q1 (make-deque))
(front-insert-deque! q1 'a)
(print-deque q1)
(front-insert-deque! q1 'b)
(print-deque q1)
(front-insert-deque! q1 'emacs)
(print-deque q1)
(rear-insert-deque! q1 'lisp)
(print-deque q1)
(front-delete-deque! q1)
(rear-delete-deque! q1)
(print-deque q1)
(rear-delete-deque! q1)
(print-deque q1)
(rear-delete-deque! q1)
(print-deque q1)
(rear-insert-deque! q1 'scheme)
(front-insert-deque! q1 'racket)
(print-deque q1)
(rear-delete-deque! q1)
(rear-delete-deque! q1)
(print-deque q1)
(front-delete-deque! q1)
(rear-delete-deque! q1)
(print-deque q1)
(rear-insert-deque! q1 'sicp)
(print-deque q1)
(front-delete-deque! q1)
(print-deque q1)

;; Method2, OO method
(define (make-deque)
  (let ((front-ptr '())
        (rear-ptr '()))
    (define (set-front-ptr! item)
      (set! front-ptr item))
    (define (set-rear-ptr! item)
      (set! rear-ptr item))
    (define (empty-deque?)
      (or (null? front-ptr) (null? rear-ptr)))
    (define (front-deque)
      (cond ((empty-deque?)
             (error "FRONT on empty deque"))
            (else
             (car front-ptr))))
    (define (rear-deque)
      (cond ((empty-deque?)
             (error "REAR on empty deque"))
            (else
             (car rear-ptr))))
    (define (front-insert-deque! item)
      (let ((new-pair (cons item '())))
        (cond ((empty-deque?)
               (set-front-ptr! new-pair)
               (set-rear-ptr! new-pair))
              (else
               (set-cdr! new-pair front-ptr)
               (set-front-ptr! new-pair)))))
    (define (rear-insert-deque! item)
      (let ((new-pair (cons item '())))
        (cond ((empty-deque?)
               (set-front-ptr! new-pair)
               (set-rear-ptr! new-pair))
              (else
               (set-cdr! rear-ptr new-pair)
               (set-rear-ptr! new-pair)))))
    (define (front-delete-deque!)
      (cond ((empty-deque?)
             (error "DELETE! called with an empty deque"))
            (else
             (set-front-ptr! (cdr front-ptr)))))
    ;; this implementation of rear-delete-deque! is O(n)
    (define (rear-delete-deque!)
      (define (iter front)
        (cond ((eq? (cdr front) rear-ptr)
               (set-cdr! front '())
               (set-rear-ptr! front))
              (else
               (iter (cdr front)))))
      (cond ((empty-deque?)
             (error "DELETE! called with an empty deque"))
            ((eq? front-ptr rear-ptr)
             (set-front-ptr! '())
             (set-rear-ptr! '()))
            (else
             (iter front-ptr))))
    (define (print-deque)
      (define (iter front rear)
        (cond ((eq? front rear)
               (display (car front)))
              (else
               (display (car front))
               (display "-")
               (iter (cdr front) rear))))
      (if (empty-deque?)
          (display "Empty deque")
          (iter front-ptr rear-ptr)))
    (define (dispatch m)
      (cond ((eq? m 'empty-deque?) empty-deque?)
            ((eq? m 'front-deque) front-deque)
            ((eq? m 'rear-deque) rear-deque)
            ((eq? m 'front-insert-deque!) front-insert-deque!)
            ((eq? m 'rear-insert-deque!) rear-insert-deque!)
            ((eq? m 'front-delete-deque!) front-delete-deque!)
            ((eq? m 'rear-delete-deque!) rear-delete-deque!)
            ((eq? m 'print-deque) print-deque)
            (else
             (error "Unknown request"))))
    dispatch))

;; test
(define q1 (make-deque))
((q1 'print-deque))
((q1 'front-insert-deque!) 'a)
((q1 'print-deque))
((q1 'front-insert-deque!) 'b)
((q1 'print-deque))
((q1 'front-insert-deque!) 'emacs)
((q1 'print-deque))
((q1 'rear-insert-deque!) 'lisp)
((q1 'print-deque))
((q1 'front-delete-deque!))
((q1 'print-deque))
((q1 'rear-delete-deque!))
((q1 'print-deque))
((q1 'rear-delete-deque!))
((q1 'print-deque))
((q1 'rear-delete-deque!))
((q1 'print-deque))
((q1 'rear-delete-deque!))
((q1 'print-deque))
((q1 'rear-insert-deque!) 'scheme)
((q1 'print-deque))
((q1 'front-insert-deque!) 'racket)
((q1 'print-deque))
((q1 'rear-delete-deque!))
((q1 'print-deque))
((q1 'front-delete-deque!))
((q1 'print-deque))
((q1 'rear-insert-deque!) 'sicp)
((q1 'print-deque))
((q1 'rear-delete-deque!))
((q1 'print-deque))
((q1 'rear-delete-deque!))
((q1 'print-deque))

