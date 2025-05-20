;; Custom variables
(defvar joj/default-font-size 140)
(defvar joj/default-variable-font-size 140)


;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(require 'use-package)
(setq use-package-always-ensure t)

;; Core settings
(setq inhibit-startup-message t
      ;; Instruct auto-save-mode to save to the current file, not a backup file
      auto-save-default nil
      ;; No backup files
      make-backup-files nil
      ;; Make it easy to cycle through previous items in the mark ring
      set-mark-command-repeat-pop t
      ;; Revert Dired and other buffers
      global-auto-revert-non-file-buffers t
      )

;; Core modes
(scroll-bar-mode 0)
(tool-bar-mode 0)
(tooltip-mode 0)
(menu-bar-mode 0)
(savehist-mode 1)           ;; Save mini-buffer history
(set-fringe-mode 5)
(column-number-mode 1)
(auto-save-visited-mode 1)  ;; Auto-save files at an interval
(global-visual-line-mode 1)
(global-auto-revert-mode 1)

;; Smooth scrolling
(setq scroll-conservatively 10
      scroll-margin 15)

(global-display-line-numbers-mode t)
;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
		term-mode-hook
		shell-mode-hook
		treemacs-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Delete trailing whitespace before saving buffers
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Fonts

(set-face-attribute 'default nil :font "Jetbrains Mono" :height joj/default-font-size)
(set-face-attribute 'fixed-pitch nil :font "Jetbrains Mono" :height joj/default-font-size)
(set-face-attribute 'variable-pitch nil :font "Cantarell" :height joj/default-variable-font-size :weight 'regular)

;; Keybinding Configuration

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Modeline

(use-package nerd-icons)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

;; Theme

(use-package doom-themes
  :init (load-theme 'doom-palenight t))

;; Which Key

(use-package which-key
  :defer 0
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.5))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
	 :map ivy-minibuffer-map
	 ("TAB" . ivy-alt-done)
	 ("C-l" . ivy-alt-done)
	 ("C-j" . ivy-next-line)
	 ("C-k" . ivy-previous-line)
	 :map ivy-switch-buffer-map
	 ("C-l" . ivy-alt-done)
	 ("C-j" . ivy-next-line)
	 ("C-k" . ivy-previous-line)
	 ("C-d" . ivy-switch-buffer-kill))
  :config
  (ivy-mode 1))

(use-package ivy-rich
  :after ivy
  :init
  (ivy-rich-mode 1))

(use-package avy
  :ensure t
  :bind (("M-j" . avy-goto-char-timer)))

(use-package jump-char
  :load-path "lisp"
  :bind (("M-m" . jump-char-forward)
         ("M-M" . jump-char-backward)))

(use-package counsel
  :bind (("C-M-j" . 'counsel-switch-buffer)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history))
  :config
  (counsel-mode 1))

(use-package helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key)
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;; Org Mode

(defun joj/org-font-setup ()
  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
		  (org-level-2 . 1.1)
		  (org-level-3 . 1.05)
		  (org-level-4 . 1.0)
		  (org-level-5 . 1.1)
		  (org-level-6 . 1.1)
		  (org-level-7 . 1.1)
		  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Jetbrains Mono" :weight 'regular :height (cdr face))))

(defun joj/org-mode-setup ()
  (org-indent-mode))

(use-package org
  :pin org
  :commands (org-capture org-agenda)
  :hook (org-mode . joj/org-mode-setup)
  :config
  (setq org-ellipsis " ▾")
  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)
  (setq org-return-follows-link t))

(require 'ox-md)

(use-package org-bullets
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(setq org-todo-keywords
      '((sequence "TODO" "NEXT" "STARTED" "WAIT" "|" "DONE" "CANCELED")))

(setq org-todo-keyword-faces
      '(("TODO" . "red")
        ("STARTED" . "orange")
        ("WAITING" . "yellow")
        ("DONE" . "green")
        ("CANCELED" . "gray")))

(use-package org-roam
  :ensure t
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/roam-notes")
  (org-roam-completion-everywhere t)
  (org-roam-dailies-capture-templates
    '(("d" "default" entry "* [%<%H:%M>] %?"
       :if-new (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n"))))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
	 ("C-c n s" . joj/counsel-rg-org-roam)
	 :map org-mode-map
         ("C-M-i" . completion-at-point)
         :map org-roam-dailies-map
         ("Y" . org-roam-dailies-capture-yesterday)
         ("T" . org-roam-dailies-capture-tomorrow))
  :bind-keymap
  ("C-c n d" . org-roam-dailies-map)
  :config
  (require 'org-roam-dailies) ;; Ensure the keymap is available
  (setq org-roam-dailies-directory "journal/")
  (org-roam-db-autosync-mode)
  (defun joj/counsel-rg-org-roam ()
  "Search org-roam notes using ripgrep, ignoring Emacs backup files."
  (interactive)
  (let* ((default-directory (expand-file-name org-roam-directory))
         (counsel-rg-base-command
          "rg -M 120 --with-filename --no-heading --line-number --color never --glob '!*~' %s"))
    (counsel-rg nil default-directory))))

(add-hook 'org-mode-hook 'visual-line-mode) ;; Enable for all org files

;; Configure Babel Languages

(with-eval-after-load 'org
  (org-babel-do-load-languages
      'org-babel-load-languages
      '((emacs-lisp . t)
      (python . t)))

  (push '("conf-unix" . conf-unix) org-src-lang-modes))

;; Structure templates

(with-eval-after-load 'org
  ;; This is needed as of Org 9.2
  (require 'org-tempo)

  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("py" . "src python")))


;; Abbreviations
(setq-default abbrev-mode t)
(define-abbrev-table 'global-abbrev-table
  '(
    ("pg" "progressive")
    ("Ne" "Next actions: ")
    ;; Add more abbreviations here
    ))

;; Magit
(use-package magit
  :bind ("C-x g" . magit-status)
  :commands (magit-status)
  :ensure t)

(defun joj/dotfiles-magit-status ()
  "Open a Magit status buffer for my ~/.dotfiles repo."
  (interactive)
  (magit-status-setup-buffer (expand-file-name "~/.dotfiles/")))
(global-set-key (kbd "C-c g d") #'joj/dotfiles-magit-status)

(defun joj/acta-magit-status ()
  "Open a Magit status buffer for the  ~/dev/automated-customer-text-analyzer repo."
  (interactive)
  (magit-status-setup-buffer (expand-file-name "~/dev/automated-customer-text-analyzer/")))
(global-set-key (kbd "C-c g a") #'joj/acta-magit-status)


(defun joj/case-cruncher-magit-status ()
  "Open a Magit status buffer for the ~/dev/cuca-case-cruncher repo."
  (interactive)
  (magit-status-setup-buffer (expand-file-name "~/dev/cuca-case-cruncher/")))
(global-set-key (kbd "C-c g c") #'joj/case-cruncher-magit-status)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("f91395598d4cb3e2ae6a2db8527ceb83fed79dbaf007f435de3e91e5bda485fb" default))
 '(package-selected-packages
   '(avy ledger-mode magit org-roam which-key use-package org-bullets ivy-rich helpful doom-themes doom-modeline counsel)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
