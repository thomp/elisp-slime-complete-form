;;; elisp-slime-complete-form.el --- Provide an elisp equivalent of SLIME-COMPLETE-FORM -*- lexical-binding: t -*-


;; Copyright (C) 2022 David Thompson
;; Author: David Thompson
;; Version: 0.1
;; URL: https://github.com/thomp/elisp-slime-complete-form

;; Package-Requires:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This package provides an elisp equivalent of SLIME-COMPLETE-FORM.

;;; Code:

(defun elisp-slime-complete-form ()
  (interactive)
  (backward-sexp)
  (let* ((sym (symbol-at-point))
	 (usage-args (when sym
		       (elisp-slime-complete-form--usage-for-function sym))))
    (when usage-args
      (forward-symbol 1)
      (let ((symbol-end (point)))
	(insert (subseq usage-args
			0
			;; let helper fns handle parens
			(1- (length usage-args))))
	(fixup-whitespace)
	(goto-char symbol-end)
	(fixup-whitespace)))))

;; adapted from help.el
(defun elisp-slime-complete-form--usage-for-function (f)
  "Grab the usage info from the docstring for function F. F should be
a symbol."
  (let* ((docstring (documentation f))
	 (found (and docstring
                     (string-match "\n\n(fn\\(\\( .*\\)?)\\)\\'" docstring))))
    (and found
         (match-string 1 docstring))))
