;;; init.el -- exactly what it looks like

;;; Commentary:
;; This just loads elisps from org files.

;;; Code:

(require 'org)
(require 'ob-tangle)



(mapc #'org-babel-load-file (directory-files "~/dotfiles" t "\\.org$"))

;;; init.el ends here
