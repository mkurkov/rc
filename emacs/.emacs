;;; File        : .emacs
;;; Description : Main Emacs configuration file
;;; Author      : Mikhail Kurkov <mkurkov@gmail.com>
;;; -------------------------------------------------------------------

;; default paths
(add-to-list 'load-path "~/rc/emacs/lib")
(setq custom-file "~/.emacs.d/custom.el")

;; package support
(load "~/rc/emacs/mk-elpa.el")
(load "~/rc/emacs/mk-use-package.el")

;; appearance tweaking
(load "~/rc/emacs/mk-user.el")
(load "~/rc/emacs/mk-lang.el")
(load "~/rc/emacs/mk-ui.el")

;; my own macroses
(load "~/rc/emacs/mk-macro.el")

;; minor modes
(load "~/rc/emacs/mk-iswitchb.el")
(load "~/rc/emacs/mk-ido.el")
(load "~/rc/emacs/mk-dired.el")
(load "~/rc/emacs/mk-uniquify.el")
(load "~/rc/emacs/mk-eproject.el")
(load "~/rc/emacs/mk-tramp.el")
(load "~/rc/emacs/mk-move-text.el")
(load "~/rc/emacs/mk-expand-region")
(load "~/rc/emacs/mk-ace-jump-mode")
(load "~/rc/emacs/mk-yasnippet")

;; vcs
(load "~/rc/emacs/mk-darcs.el")
(load "~/rc/emacs/mk-magit")

;; gtd
(load "~/rc/emacs/mk-org-mode.el")
(load "~/rc/emacs/mk-remember.el")

;; programming
(load "~/rc/emacs/mk-sql.el")
(load "~/rc/emacs/mk-j.el")
(load "~/rc/emacs/mk-haskell")
(load "~/rc/emacs/mk-erlang.el")
(load "~/rc/emacs/mk-shell.el")
(load "~/rc/emacs/mk-ruby.el")
(load "~/rc/emacs/mk-compilation.el")
(load "~/rc/emacs/mk-webdev")
(load "~/rc/emacs/mk-typescript")

;; editing
(load "~/rc/emacs/mk-markdown")
(load "~/rc/emacs/mk-graphviz")
(load "~/rc/emacs/mk-tex")
(load "~/rc/emacs/mk-xml")
(load "~/rc/emacs/mk-string-inflection")

;; IRC
(load "~/rc/emacs/mk-erc.el")

;; Mailing
(load "~/rc/emacs/mk-gnus.el")

;; load saved sessions afterall
(load "~/rc/emacs/mk-desktop.el")

;; server start
(server-start)
