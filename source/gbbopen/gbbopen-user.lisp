;;;; -*- Mode:Common-Lisp; Package:GBBOPEN-USER; Syntax:common-lisp -*-
;;;; *-* File: /usr/local/gbbopen/source/gbbopen/gbbopen-user.lisp *-*
;;;; *-* Edited-By: cork *-*
;;;; *-* Last-Edit: Sun Aug 31 16:36:05 2008 *-*
;;;; *-* Machine: cyclone.cs.umass.edu *-*

;;;; **************************************************************************
;;;; **************************************************************************
;;;; *
;;;; *                      GBBopen-User Package
;;;; *
;;;; **************************************************************************
;;;; **************************************************************************
;;;
;;; Written by: Dan Corkill
;;;
;;; Copyright (C) 2004-2008, Dan Corkill <corkill@GBBopen.org>
;;; Part of the GBBopen Project (see LICENSE for license information).
;;;
;;; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;;;
;;;  01-08-04 File created.  (Corkill)
;;;  01-17-06 Use :module-manager package.  (Corkill)
;;;
;;; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

(eval-when (:compile-toplevel :load-toplevel :execute)
  (unless (find-package ':gbbopen-user)
    (make-package ':gbbopen-user
                  :use '(:common-lisp :module-manager
                         :gbbopen-tools :gbbopen))))

(in-package :gbbopen-user)

(pushnew ':gbbopen-user *features*)

;;; ===========================================================================
;;;				  End of File
;;; ===========================================================================


