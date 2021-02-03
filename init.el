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
    :init
    (leaf el-get :ensure t)
    :config
    ;; initialize leaf-keywords.el
    (leaf-keywords-init)))

(leaf leaf-tree :ensure t)
(leaf leaf-convert :ensure t)

(leaf exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

(leaf undo-tree
    :ensure t
    :require t
    :global-minor-mode global-undo-tree-mode)

(leaf evil
  :ensure t
  :require t
  :defvar (evil-want-integration
           evil-want-keybinding)
  :init
  (setf evil-want-integration t)
  (setf evil-want-keybinding nil)
  :custom ((evil-want-Y-yank-to-eol . t)
	   (evil-shift-width . 2)
           (evil-undo-system . 'undo-tree))
  :bind ((:evil-insert-state-map
          ("C-l" . evil-normal-state))
         (:evil-visual-state-map
          ("C-l" . evil-normal-state))
         (:evil-normal-state-map
          ("C-l" . nil))
         (:evil-motion-state-map
          ("j" . evil-next-visual-line)
          ("k" . evil-previous-visual-line)
          ("SPC" . nil)
          ("SPC -" . evil-window-split)
          ("SPC |" . evil-window-vsplit)
          ("SPC d f" . describe-function)
          ("SPC d v" . describe-variable)
          ("SPC d s" . describe-symbol)
          ("SPC d k" . describe-key)
          ("SPC d p" . describe-package)))
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
  (evil-define-command evil-tab-sensitive-quit (&optional bang)
    :repeat nil
    (interactive "<!>")
    (cond
      ((> (length (window-list)) 1) (delete-window))
      ((> (length (eyebrowse--get 'window-configs)) 1) (eyebrowse-close-window-config))
      (t (evil-quit bang))))
  (evil-define-command evil-tab-sensitive-wq (&optional bang)
    :repeat nil
    (interactive "<!>")
    (save-buffer)
    (evil-tab-sensitive-quit bang))
  (evil-ex-define-cmd "q[uit]" 'evil-tab-sensitive-quit)
  (evil-ex-define-cmd "wq" 'evil-tab-sensitive-wq))

(leaf eyebrowse
    :ensure t
    :require t
    :after evil
    :custom ((eyebrowse-wrap-around . t))
    :bind ((:evil-motion-state-map
            :package evil
            ("g t" . eyebrowse-next-window-config)
            ("g T" . eyebrowse-prev-window-config)
            ("SPC 0" . eyebrowse-switch-to-window-config-0)
            ("SPC 1" . eyebrowse-switch-to-window-config-1)
            ("SPC 2" . eyebrowse-switch-to-window-config-2)
            ("SPC 3" . eyebrowse-switch-to-window-config-3)
            ("SPC 4" . eyebrowse-switch-to-window-config-4)
            ("SPC 5" . eyebrowse-switch-to-window-config-5)
            ("SPC 6" . eyebrowse-switch-to-window-config-6)
            ("SPC 7" . eyebrowse-switch-to-window-config-7)
            ("SPC 8" . eyebrowse-switch-to-window-config-8)
            ("SPC 9" . eyebrowse-switch-to-window-config-9)
            ("SPC w" . eyebrowse-switch-to-window-config)
            ("SPC W" . eyebrowse-create-window-config)
            ("SPC C-w" . eyebrowse-create-named-window-config))
           (:evil-normal-state-map
             :package evil
             ("g t" . eyebrowse-next-window-config)
             ("g T" . eyebrowse-prev-window-config)))
    :global-minor-mode eyebrowse-mode
    :config
    (defun find-file-in-new-workspace (file)
      (interactive "Gfind file in tab: ")
      (eyebrowse-create-window-config)
      (find-file file))
    (evil-define-command evil-eyebrowse-tabedit (file)
                        :repeat nil
                        (interactive "<f>")
                        (find-file-in-new-workspace file))
    (evil-ex-define-cmd "tabnew" 'eyebrowse-create-window-config)
    (evil-ex-define-cmd "tabe[dit]" 'find-file-in-new-workspace))

(leaf gruvbox-theme
  :ensure t
  :config
  (load-theme 'gruvbox-dark-soft t))

(leaf lsp-mode
  :ensure t
  :hook (((python-mode-hook c-mode-hook c++-mode-hook LaTeX-mode-hook haskell-mode-hook julia-mode-hook) . lsp)
         (lsp-mode-hook . lsp-enable-which-key-integration))
  :config
  (leaf lsp-ui
    :ensure t)
  (leaf lsp-latex
    :ensure t
    :require t
    :custom ((lsp-latex-build-on-save . t)))
  (leaf lsp-julia
      :ensure t))

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
  :bind ((:yas-minor-mode-map ("C-c y" . yas-expand)))
  :config
  (leaf yasnippet-snippets
    :ensure t))

(leaf hydra
  :ensure t)

(leaf counsel
  :ensure t
  :after evil
  :custom ((ivy-use-virtual-buffers . t)
           (ivy-count-format . "%d/%d "))
  :global-minor-mode ivy-mode
  :config
  (leaf ivy-hydra
      :ensure t)
  (defun swiper-isearch-save-direction (&optional initial-input)
    "swiper-isearch which saves its direction to isearch-forward"
    (interactive)
    (swiper-isearch initial-input)
    (setf isearch-forward t))
  (defun swiper-isearch-backward-save-direction (&optional initial-input)
    "swiper-isearch-backward which saves its direction to isearch-forward"
    (interactive)
    (swiper-isearch-backward initial-input)
    (setf isearch-forward nil))
  (evil-global-set-key 'motion (kbd "/") 'swiper-isearch-save-direction)
  (evil-global-set-key 'motion (kbd "?") 'swiper-isearch-backward-save-direction)
  (evil-global-set-key 'motion (kbd "SPC f") 'counsel-find-file)
  (evil-global-set-key 'motion (kbd "SPC F") 'counsel-dired-file)
  (evil-global-set-key 'motion (kbd "SPC b") 'counsel-switch-buffer))

(leaf magit
    :ensure t
    :config
    (leaf evil-magit
        :ensure t
        :require t))

(leaf which-key
  :ensure t
  :global-minor-mode which-key-mode)

(leaf vterm
    :ensure t
    :bind ((:evil-motion-state-map
            :package evil
            ("SPC r" . vterm-repl)))
    :config
    (defun vterm-repl (command)
      (interactive "sREPL command: ")
      (let ((vterm-shell command))
        (vterm))))

;;; sly
(load (expand-file-name "~/.roswell/helper.el"))

(leaf haskell-mode
  :ensure t)

(leaf python
    :tag "builtin"
    :custom ((python-shell-interpreter . "python3")))

(leaf hy-mode
    :ensure t
    :hook (hy-mode-hook . (lambda ()
                            (evil-local-set-key 'motion
                                                "SPC i"
                                                'hy-jedhy-update-imports))))

(leaf racket-mode
  :ensure t)

(leaf plisp-mode
    :ensure t)

(leaf ess
    :ensure t)

(leaf julia-mode
    :ensure t
    :config
    (leaf ob-julia
        :el-get (ob-julia
                 :url "https://git.nixo.xyz/nixo/ob-julia.git")
        :after ess-inf))

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

(leaf gnuplot
    :ensure t
    :commands (gnuplot-mode gnuplot-make-buffer)
    :init
    (add-to-list 'auto-mode-alist '("\\.gp$" . gnuplot-mode)))

(leaf org
  :tag "builtin"
  :after yasnippet company
  :custom ((org-startup-truncated . nil)
           (org-startup-indented . t)
           (org-image-actual-width . 500)
           (org-latex-compiler . "lualatex")
           (org-latex-pdf-process . '("latexmk -output-directory=%o %f"))
           (org-latex-packages-alist . '(("" "luatexja-fontspec" nil '("lualatex"))))
           (org-latex-default-class . "ltjsarticle")
           (org-latex-prefer-user-labels . t)
           (org-babel-python-command . "python3")
           (org-ditaa-jar-path . "/usr/local/Cellar/ditaa/0.11.0_1/libexec/ditaa-0.11.0-standalone.jar")
           (org-confirm-babel-evaluate . nil)
           (org-format-latex-header . "\\documentclass[ja=standard]{bxjsarticle}
\\usepackage[usenames]{color}
[PACKAGES]
[DEFAULT-PACKAGES]
\\pagestyle{empty}             % do not remove
\\usepackage{arev}
% The settings below are copied from fullpage.sty
\\setlength{\\textwidth}{\\paperwidth}
\\addtolength{\\textwidth}{-3cm}
\\setlength{\\oddsidemargin}{1.5cm}
\\addtolength{\\oddsidemargin}{-2.54cm}
\\setlength{\\evensidemargin}{\\oddsidemargin}
\\setlength{\\textheight}{\\paperheight}
\\addtolength{\\textheight}{-\\headheight}
\\addtolength{\\textheight}{-\\headsep}
\\addtolength{\\textheight}{-\\footskip}
\\addtolength{\\textheight}{-3cm}
\\setlength{\\topmargin}{1.5cm}
\\addtolength{\\topmargin}{-2.54cm}")
           (org-format-latex-options . '(:foreground "White"
                                         :background default
                                         :scale 1.5
                                         :html-foreground "Black"
                                         :html-background "Transparent"
                                         :html-scale 1.0
                                         :matchers ("begin" "$1" "$" "$$" "\\(" "\\["))))
  :hook (org-mode-hook . (lambda ()
                           (set (make-local-variable 'company-backends) '((company-dabbrev company-yasnippet)))))
  :bind (:evil-motion-state-map
         :package evil
         ("SPC a" . org-agenda))
  :config
  (defvar org-config-executed t)
  (with-eval-after-load 'ox-latex
    (add-to-list 'org-latex-classes '("ltjsarticle" "\\documentclass[11pt]{ltjsarticle}"
                                      ("\\section{%s}" . "\\section*{%s}")
                                      ("\\subsection{%s}" . "\\subsection*{%s}")
                                      ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                                      ("\\paragraph{%s}" . "\\paragraph*{%s}")
                                      ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))
  (add-to-list 'org-src-lang-modes '("Hy" . hy))
  (add-to-list 'org-babel-load-languages '(python . t))
  (add-to-list 'org-babel-load-languages '(gnuplot . t))
  (add-to-list 'org-babel-load-languages '(shell . t))
  (add-to-list 'org-babel-load-languages '(picolisp . t))
  (add-to-list 'org-babel-load-languages '(scheme . t))
  (add-to-list 'org-babel-load-languages '(julia . t))
  (org-babel-do-load-languages 'org-babel-load-languages '((python . t) (gnuplot . t) (shell . t) (picolisp . t)
                                                           (scheme . t) (julia . t)))
  (leaf ox-latex-subfigure
      :ensure t
      :require t
      :after org)
  (leaf org-ref
      :ensure t
      :require t
      :after org
      :pre-setq (org-ref-completion-library . 'org-ref-ivy-cite)
      :custom ((reftex-default-bibliography . '("~/Documents/bibliography/references.bib"))
               (org-ref-bibliography-notes . "~/Documents/bibliography/bibliography-notes.org")
               (org-ref-pdf-directory . "~/Documents/bibliography/bibtex-pdfs"))))

(leaf auctex
  :ensure t
  :hook ((LaTeX-mode-hook . LaTeX-math-mode))
  :custom ((japanese-TeX-engine-default . 'luatex)
           (TeX-default-mode . 'japanese-latex-mode)
           (japanese-LaTeX-default-style . "ltjsarticle")))

(leaf paredit
  :ensure t
  :hook ((lisp-mode-hook emacs-lisp-mode-hook ielm-mode-hook hy-mode-hook scheme-mode-hook racket-mode-hook racket-repl-mode-hook) . enable-paredit-mode))

(leaf doc-view
  :tag "builtin"
  :custom ((doc-view-ghostscript-program . "gs-noX11-Yosemite")
           (doc-view-continuous . t))
  :hook (doc-view-mode-hook . auto-revert-mode))

(leaf paren
  :tag "builtin"
  :custom ((show-paren-delay . 0))
  :global-minor-mode show-paren-mode)

(leaf autorevert
    :tag "builtin"
    :global-minor-mode global-auto-revert-mode)

(leaf display-line-numbers
  :tag "builtin"
  :global-minor-mode global-display-line-numbers-mode)

(leaf eshell
  :tag "builtin"
  :require em-alias
  :custom ((eshell-cmpl-ignore-case . t))
  :defun (new-shell-in-tab)
  :bind ((:evil-motion-state-map
          :package evil
          ("SPC t" . new-shell-in-tab)))
  :config
  (eshell/alias "ll" "ls -la $*")
  (eshell/alias "la" "ls -a $*")
  (eshell/alias "l" "ls -la $*")
  (eshell/alias "emacs" "find-file $1")
  (eshell/alias "tabedit" "evil-eyebrowse-tabedit $1")
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
    "Opens a fresh eshell in a new window config."
    (interactive)
    (let ((dir default-directory))
      (eyebrowse-create-window-config)
      (new-shell dir))))


(tool-bar-mode -1)
(scroll-bar-mode -1)
(setf inhibit-startup-screen t)
(setq-default indent-tabs-mode nil)
(electric-pair-mode 1)
(setf backup-directory-alist '(("." . "~/.emacs-backup")))
(setf default-frame-alist
      '((width . 125)
        (height . 60)
        (left . 500)
        (top . 50)
        (font . "Menlo 14")))
(set-face-attribute 'default t :font "Menlo 10")
(server-start)
(setf lisp-indent-function 'common-lisp-indent-function)

(defun edit-config ()
  "Edit init.el."
  (interactive)
  (eyebrowse-create-window-config)
  (find-file "~/dotfiles/init.el"))

(when (equal default-directory "/")
  (setf default-directory "~"))

(setf custom-file "~/.emacs.d/custom.el")
(load-file custom-file)
