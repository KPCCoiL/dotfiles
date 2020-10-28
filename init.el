(eval-and-compile
  (customize-set-variable
   'package-archives '(("org" . "https://orgmode.org/elpa/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("gnu" . "https://elpa.gnu.org/packages/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    :config
    ;; initialize leaf-keywords.el
    (leaf-keywords-init)))

(leaf leaf-tree :ensure t)
(leaf leaf-convert :ensure t)

(leaf exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

(leaf evil
  :ensure t
  :require t
  :defvar (evil-want-integration
           evil-want-keybinding
           evil-respect-visual-line-mode)
  :init
  (setf evil-want-integration t)
  (setf evil-want-keybinding nil)
  (setf evil-respect-visual-line-mode t)
  :custom ((evil-want-Y-yank-to-eol . t)
	   (evil-shift-width . 2))
  :bind ((:evil-insert-state-map
	  ("C-l" . evil-normal-state))
         (:evil-visual-state-map
          ("C-l" . evil-normal-state)))
  :config
  (evil-mode 1)
  (leaf evil-collection
    :ensure t
    :require t
    :config (evil-collection-init))
  (leaf evil-surround
    :ensure t
    :require t
    :global-minor-mode global-evil-surround-mode)
  (leaf evil-tabs
    :ensure t
    :require t
    :global-minor-mode global-evil-tabs-mode
    :config
    (evil-define-command evil-tab-sensitive-quit (&optional bang)
      :repeat nil
      (interactive "<!>")
      (cond
       ((> (length (window-list)) 1) (delete-window))
       ((> (length (elscreen-get-screen-list)) 1) (elscreen-kill))
       (t (evil-quit bang))))
    (evil-define-command evil-tab-sensitive-wq (&optional bang)
      :repeat nil
      (interactive "<!>")
      (save-buffer)
      (evil-tab-sensitive-quit bang))
    (evil-ex-define-cmd "q[uit]" 'evil-tab-sensitive-quit)
    (evil-ex-define-cmd "wq" 'evil-tab-sensitive-wq)))

(leaf gruvbox-theme
  :ensure t
  :config
  (load-theme 'gruvbox-dark-soft t))

(leaf lsp-mode
  :ensure t
  :hook (((python-mode-hook c-mode-hook c++-mode-hook latex-mode-hook haskell-mode-hook) . lsp))
  :config
  (leaf lsp-ui
    :ensure t)
  (leaf lsp-latex
    :ensure t
    :require t
    :custom ((lsp-latex-build-on-save . t))))

(leaf company
  :ensure t
  :custom ((company-idle-delay . 0))
  :global-minor-mode global-company-mode)


(leaf flycheck
  :ensure t
  :global-minor-mode global-flycheck-mode)

(leaf yasnippet
  :ensure t
  :global-minor-mode yas-global-mode
  :config
  (leaf yasnippet-snippets
    :ensure t))

(leaf hydra
  :ensure t)

(leaf counsel
  :ensure t
  :custom ((ivy-use-virtual-buffers . t)
           (ivy-count-format . "%d/%d "))
  :global-minor-mode ivy-mode
  :config
  (leaf ivy-hydra
    :ensure t)
  (leaf swiper
    :bind ((:evil-normal-state-map
            ("/" . swiper-isearch-backward)
            ("?" . swiper-isearch)))))

(leaf magit
  :ensure t)

(leaf which-key
  :ensure t
  :global-minor-mode which-key-mode)

;;; sly
(load (expand-file-name "~/.roswell/helper.el"))

(leaf hy-mode
  :ensure t)

(leaf racket-mode
  :ensure t)

(leaf agda2
  :require t
  :custom (agda2-backend . "GHC")
  :load-path `(,(let* ((coding-system-for-read 'utf-8))
                  (substring
                   (shell-command-to-string "agda-mode locate")
                   0
                   (- (length "/agda2.el")))))
  :hook (agda2-mode-hook . (lambda ()
                             (setenv "GHC_ENVIRONMENT" "agda")
                             (set-input-method "Agda"))))

;; (leaf auctex
;;   :ensure t
;;   :custom ((japanese-TeX-engine-default . 'luatex)
;;            (TeX-default-mode . 'japanese-latex-mode)
;;            (japanese-LaTeX-default-style . "ltjsarticle")))

(leaf paredit
  :ensure t
  :hook ((lisp-mode-hook emacs-lisp-mode-hook hy-mode-hook racket-mode-hook racket-repl-mode-hook) . enable-paredit-mode))

(leaf doc-view
  :tag "builtin"
  :custom ((doc-view-ghostscript-program . "gs-noX11-Yosemite")
           (doc-view-continuous . t))
  :hook (doc-view-mode-hook . auto-revert-mode))

(leaf paren
  :tag "builtin"
  :custom ((show-paren-delay . 0))
  :global-minor-mode show-paren-mode)

(leaf display-line-numbers
  :tag "builtin"
  :global-minor-mode global-display-line-numbers-mode)

(leaf eshell
  :tag "builtin"
  :require em-alias
  :custom ((eshell-cmpl-ignore-case . t))
  :defun (new-shell-in-tab)
  :config
  (eshell/alias "ll" "ls -la $*")
  (eshell/alias "la" "ls -a $*")
  (eshell/alias "l" "ls -la $*")
  (eshell/alias "emacs" "find-file $1")
  (eshell/alias "tabedit" "elscreen-find-file $1")
  (defun new-shell (&optional start-directory)
    "Opens a fresh eshell."
    (interactive)
    (let ((start-dir (or start-directory default-directory))
          (shell-buffer (eshell 'N)))
      (with-current-buffer shell-buffer
        (eshell-return-to-prompt)
        (insert (concat "cd " start-dir))
        (eshell-send-input))))
  (defun new-shell-in-tab ()
    "Opens a fresh eshell in a new elscreen."
    (interactive)
    (let ((dir default-directory))
      (elscreen-create)
      (new-shell dir)))
  (evil-global-set-key 'normal (kbd "M-RET") 'new-shell-in-tab))



(tool-bar-mode -1)
(scroll-bar-mode -1)
(setf inhibit-startup-screen t)
(setq-default indent-tabs-mode nil)
(electric-pair-mode 1)
(global-visual-line-mode)
(setf backup-directory-alist '(("." . "~/.emacs-backup")))
(setf default-frame-alist
      '((width . 125)
        (height . 60)
        (left . 500)
        (top . 50)
        (font . "Menlo 14")))
(set-face-attribute 'default t :font "Menlo 10")
(server-start)

(defun edit-config ()
  "Edit init.el."
  (interactive)
  (elscreen-find-file "~/.emacs.d/init.el"))

(when (equal default-directory "/")
  (setf default-directory "~"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(evil-respect-visual-line-mode t)
 '(evil-shift-width 2)
 '(evil-want-Y-yank-to-eol t)
 '(package-archives
   '(("org" . "https://orgmode.org/elpa/")
     ("melpa" . "https://melpa.org/packages/")
     ("gnu" . "https://elpa.gnu.org/packages/")))
 '(package-selected-packages
   '(ivy-hydra lsp-latex leaf-convert leaf-tree leaf-keywords evil)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
