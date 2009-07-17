;;;; -*- Mode:Common-Lisp; Package:GBBOPEN-TOOLS; Syntax:common-lisp -*-
;;;; *-* File: /usr/local/gbbopen/source/tools/test/llrb-tree-test.lisp *-*
;;;; *-* Edited-By: cork *-*
;;;; *-* Last-Edit: Fri Jul 17 10:31:29 2009 *-*
;;;; *-* Machine: cyclone.cs.umass.edu *-*

;;;; **************************************************************************
;;;; **************************************************************************
;;;; *
;;;; *                              LLRB Tree Tests
;;;; *
;;;; **************************************************************************
;;;; **************************************************************************

(in-package :gbbopen-tools)

(defvar *x* nil)

;;; ---------------------------------------------------------------------------

(defun check-traversal (llrb-tree)
  (let ((last-key -infinity&))
    (map-llrb-tree
     #'(lambda (key value)
         (declare (ignore value))
         (unless (>& key last-key)
           (error "Wrong key ordering"))
         (setf last-key key))
     llrb-tree)))

;;; ---------------------------------------------------------------------------

(defun print-tree (node &optional (indent 0))
  (when node
    (let ((left (rbt-node-right node))
	  (right (rbt-node-left node)))
      (when left
	(print-tree left (1+& indent)))
      (loop for i from 1 to indent
          do (format t "  "))
      (format t "~a ~:[B~;R~]~%" (rbt-node-key node) (rbt-node-is-red? node))
      (when right
	(print-tree right (1+& indent))))))

;;; ---------------------------------------------------------------------------

(defun llrb-print (node)
  (llrb-prefix-map #'(lambda (node) (format t "~&~s~%" node))
                   node)
  (values))

;;; ---------------------------------------------------------------------------

(defun new (n) 
  (setf *x* (llrb-insert n *x* n))
  (llrb-print *x*))       

;;; ---------------------------------------------------------------------------

(defun count-nodes (llrb-tree)
  (let ((count 0))
    (flet ((count-it (key value)
             (declare (ignore key value))
             (incf& count)))
      (map-llrb-tree #'count-it llrb-tree))
    count))

;;; ===========================================================================
;;;   Timing

(defun big-test (n)
  ;; Build the test-data hash table:
  (let ((numbers (make-hash-table :size n))
        tree
        ht
        continuep 
        key)
    (declare (ignorable continuep))     ; for CL's that optimize this var away!
    (dotimes (i n)
      (let ((key (random n)))
        (setf (gethash key numbers) key)))
    (format t "~&;; Numbers: ~a~%" (hash-table-count numbers))
    ;; Build the LLRH tree:
    (printv "Building LLRH tree:")
    (time
     (with-hash-table-iterator (next numbers)
       (setf tree (make-llrb-tree #'compare&))
       (while (multiple-value-setq (continuep key) (next))
         (llrb-tree-insert key tree key))))
    (unless (= (hash-table-count numbers) (count-nodes tree))
      (error "Wrong count"))
    (check-traversal tree)
    ;; Now build the hash table:
    (printv "Building hash table:")
    (time
     (with-hash-table-iterator (next numbers)
       (setf ht (make-hash-table :size (hash-table-count numbers)))
       (while (multiple-value-setq (continuep key) (next))
         (setf (gethash key ht) key))))
    ;; LLRH retrievals:
    (printv "LLRB retrievals:")
    (time
     (with-hash-table-iterator (next numbers)
       (while (multiple-value-setq (continuep key) (next))
         (unless (get-llrb-tree-node key tree)
           (error "Did not retrieve ~s" key)))))
    ;; Hash-table retrievals:
    (printv "Hash-table retrievals:")
    (time
     (with-hash-table-iterator (next numbers)
       (while (multiple-value-setq (continuep key) (next))
         (gethash key ht))))
    ;; Now delete about 1/2 of the numbers in the test data:
    (with-hash-table-iterator (next numbers)
       (while (multiple-value-setq (continuep key) (next))
         (when (plusp& (random 2)) (remhash key numbers))))
    (let ((remaining-numbers (-& (hash-table-count ht)
                                 (hash-table-count numbers))))
      (format t "~&;; Remaining numbers: ~a~%" remaining-numbers)
      ;; LLRH deletes:
      (printv "LLRB deletes:")
      (time
       (with-hash-table-iterator (next numbers)
         (while (multiple-value-setq (continuep key) (next))
           (llrb-tree-delete key tree))))
      ;; Hash-table deletes:
      (printv "Hash-table deletes:")
      (time
       (with-hash-table-iterator (next numbers)
         (while (multiple-value-setq (continuep key) (next))
           (remhash key ht))))
      (let ((count (count-nodes tree)))
        (unless (= (hash-table-count ht) count)
          (error "Wrong count after deletes: ~s" count))))))

;;; ===========================================================================
;;;  Trip test

(eval-when (:compile-toplevel :load-toplevel :execute)

  (defmacro logger ((s &body setup) &body body) 
    `(progn (format t "~&;; ~40,,,'-<-~>~%;; ~a~%" ,s)
            ,@setup
            (llrb-print *x*)
            ,@body
            (if *x* 
                (llrb-print *x*) 
                (format t "#<empty>~%")))))

(defun test (&optional print-trees?)
  (format t "~&;; Starting LLRB trees tests...~%")
  (logger ("Delete missing from empty tree:"
           (setf *x* nil))
          (setf *x* (llrb-delete 5 *x*)))
  (when print-trees? (print-tree *x*))
  (logger ("Delete root:"
           (setf *x* (make-llrb-root 5 5)))
          (setf *x* (llrb-delete 5 *x*)))
  (when print-trees? (print-tree *x*))
  (logger ("Delete missing (left) from singleton tree:"
           (setf *x* (make-llrb-root 5 5)))
          (setf *x* (llrb-delete 1 *x*)))
  (when print-trees? (print-tree *x*))
  (logger ("Delete missing (right) from singleton tree:"
           (setf *x* (make-llrb-root 5 5)))
          (setf *x* (llrb-delete 9 *x*)))
  (when print-trees? (print-tree *x*))
  (logger ("Delete 1 from 5-1 tree:"
           (setf *x* (make-llrb-root 5 5))
           (setf *x* (llrb-insert 1 *x* 1)))
          (setf *x* (llrb-delete 1 *x*)))
  (when print-trees? (print-tree *x*))
  (logger ("Delete 9 from 1-5-9 tree:"
           (setf *x* (make-llrb-root 5 5))
           (setf *x* (llrb-insert 1 *x* 1))
           (setf *x* (llrb-insert 9 *x* 1)))
          (setf *x* (llrb-delete 9 *x*)))
  (when print-trees? (print-tree *x*))
  (logger ("Make 1:8 tree:"
           (setf *x* (make-llrb-root 1 1))
           (loop for i from 2 to 8 do
		(setf *x* (llrb-insert i *x* i)))))  
  (when print-trees? (print-tree *x*))
  (logger ("Delete 5 from 5-1 tree:"
           (setf *x* (make-llrb-root 5 5))
           (setf *x* (llrb-insert 1 *x* nil))
	   (setf *x* (llrb-delete 5 *x*))))
  (when print-trees? (print-tree *x*))
  (format t "~&;; Completed LLRB trees tests.~%"))

;;; ---------------------------------------------------------------------------

(when *autorun-modules*
  (test))
  
;;; ===========================================================================
;;;				  End of File
;;; ===========================================================================
