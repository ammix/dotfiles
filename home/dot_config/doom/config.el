;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Maxim Dewald"
      user-mail-address "maxim@ammix.dev")

(setenv "SSH_AUTH_SOCK" (expand-file-name "~/.1password/agent.sock"))

;; Font configuration
(setq doom-font (font-spec :family "FiraCode Nerd Font" :size 17))

;; Theme configuration
;; Load definitions first so Doom enables Catppuccin with the overridden palette.
(setq doom-theme 'catppuccin)
(load-theme 'catppuccin t t)
(catppuccin-set-color 'base "#11111b" 'mocha)
(catppuccin-reload)

;; Doom dashboard
(defconst maxim/doom-dashboard-image-file "flowers-13.jpg")

(defun maxim/doom-dashboard-widget-welcome ()
  (let* ((text (propertize "Welcome, Maxim!"
                           'face '(:foreground "#cba6f7" :weight bold)))
         (prefix (propertize
                  " " 'display
                  `(space :align-to (- center ,(/ (+dashboard-strlen text) 2.0))))))
    (insert prefix text "\n")))

(defun maxim/doom-dashboard-widget-footer ()
  (let ((map (make-sparse-keymap)))
    (define-key map [mouse-1]
                (lambda ()
                  (interactive)
                  (browse-url "https://github.com/doomemacs")))
    (+dashboard-insert
     (with-temp-buffer
       (insert (propertize " " 'display '(space . (:relative-height 2.0))) "\n")
       (insert (propertize (or (nerd-icons-codicon "nf-cod-octoface"
                                                   :face '+dashboard-footer-icon
                                                   :height 1.3
                                                   :v-adjust -0.15)
                               "github")
                           'mouse-face 'highlight
                           'local-map map
                           'help-echo "Open Doom Emacs github page"))
       (insert "\n")
       (buffer-string)))))

(let ((image-path (expand-file-name maxim/doom-dashboard-image-file doom-user-dir)))
  (unless (file-readable-p image-path)
    (user-error "Doom dashboard image is missing or unreadable: %s" image-path))
  (setq +dashboard-banner-dir doom-user-dir
        +dashboard-banner-file maxim/doom-dashboard-image-file
        fancy-splash-image image-path
        +dashboard-functions
        '(+dashboard-widget-banner
          maxim/doom-dashboard-widget-welcome
          maxim/doom-dashboard-widget-footer)))

;; Disable GTK bars and titlebar for pgtk
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(add-to-list 'initial-frame-alist '(fullscreen . maximized))
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(add-to-list 'default-frame-alist '(undecorated . t))

;; Transparent background (requires Emacs 29+)
(add-to-list 'default-frame-alist '(alpha-background . 90))

;; Line numbers configuration - relative line numbers
(setq display-line-numbers-type 'relative)

;; Org directory
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; org mode bullet
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

;; Shell configuration - set fish as default shell
(setq shell-file-name (or (executable-find "fish") "/usr/bin/fish")
      vterm-shell (or (executable-find "fish") "/usr/bin/fish")
      explicit-shell-file-name (or (executable-find "fish") "/usr/bin/fish"))

;; direnv configuration
(after! direnv
  (direnv-mode))

;; Environment variable handling
(after! envrc
  (envrc-global-mode))

;; Rust-specific configuration
(after! rustic
  (setq rustic-format-on-save t)
  (setq rustic-lsp-client 'lsp-mode))

(use-package! nushell-ts-mode
  :mode ("\\.nu\\'" . nushell-ts-mode)
  :interpreter ("nu" . nushell-ts-mode))

(map! :n "-" 'dired-jump)
(map! :n "RET" (cmd! (let ((current-prefix-arg t))
                       (evil-avy-goto-char-timer))))
;; Harpoon
;; You can use this hydra menu that have all the commands
(map! :n "C-SPC" 'harpoon-quick-menu-hydra)
(map! :n "C-s" 'harpoon-add-file)

;; And the vanilla commands
(map! :leader "j c" 'harpoon-clear)
(map! :leader "j f" 'harpoon-toggle-file)
(map! :leader "1" 'harpoon-go-to-1)
(map! :leader "2" 'harpoon-go-to-2)
(map! :leader "3" 'harpoon-go-to-3)
(map! :leader "4" 'harpoon-go-to-4)
(map! :leader "5" 'harpoon-go-to-5)
(map! :leader "6" 'harpoon-go-to-6)
(map! :leader "7" 'harpoon-go-to-7)
(map! :leader "8" 'harpoon-go-to-8)
(map! :leader "9" 'harpoon-go-to-9)

;; Shell command keybind
(map! :leader "r" 'shell-command)

;; Compilation
(setq compile-command "just")

(defun maxim/compile-interactive ()
  (interactive)
  (let ((current-prefix-arg '(4)))
    (call-interactively #'compile)))

(map! :leader
      "c C" #'maxim/compile-interactive)
