;;;; -*- Mode:Common-Lisp; Package:GBBOPEN-TOOLS; Syntax:common-lisp -*-
;;;; *-* File: /usr/local/gbbopen/source/tools/gbbopen-instance.lisp *-*
;;;; *-* Edited-By: cork *-*
;;;; *-* Last-Edit: Sun Jun 21 04:12:59 2009 *-*
;;;; *-* Machine: cyclone.cs.umass.edu *-*

;;;; **************************************************************************
;;;; **************************************************************************
;;;; *
;;;; *                      Standard GBBopen Instance
;;;; *
;;;; **************************************************************************
;;;; **************************************************************************
;;;
;;; Written by: Dan Corkill
;;;
;;; Copyright (C) 2006-2009, Dan Corkill <corkill@GBBopen.org>
;;; Part of the GBBopen Project (see LICENSE for license information).
;;;
;;; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;;;
;;;  04-06-06 File created.  (Corkill)
;;;  06-20-09 Added PRINT-INSTANCE-SLOT-VALUE.  (Corkill)
;;;
;;; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

(in-package :gbbopen-tools)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (export '(print-instance-slots
            print-instance-slot-value
            standard-gbbopen-instance)))

(defgeneric print-instance-slots (instance stream))
(defgeneric print-instance-slot-value (instance slot-name stream))

;;; ---------------------------------------------------------------------------

(define-class standard-gbbopen-instance ()
  ()
  (:export-class-name t))

;;; ---------------------------------------------------------------------------

(defmethod print-object ((instance standard-gbbopen-instance) stream)
  (cond (*print-readably* (call-next-method))
        (t (print-unreadable-object (instance stream :type nil)
             (print-instance-slots instance stream))
           ;; Print-object must return object:
           instance)))

;;; ---------------------------------------------------------------------------
;;;  Print instance slots (extension of print-object method for
;;;  standard-gbbopen-instance objects)

(defmethod print-instance-slots ((instance standard-gbbopen-instance) stream)
  (format stream "~s" (type-of instance))
  nil)

;;; ---------------------------------------------------------------------------
;;;  Print instance slot value

(defmethod print-instance-slot-value ((instance standard-gbbopen-instance) 
                                      slot-name
                                      stream)
  (if (slot-boundp instance slot-name)
      (format stream " ~s" (slot-value instance slot-name))
      (princ " <unbound>" stream)))

;;; ===========================================================================
;;; End of File
;;; ===========================================================================
