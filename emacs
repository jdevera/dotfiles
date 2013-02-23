;; El-Get {{{
;; --------------------------------------------------------------------------
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (let (el-get-master-branch)
      (goto-char (point-max))
      (eval-print-last-sexp))))

;; Local Sources
(setq el-get-sources
      '(
        ;; Use apt, since default recipe compiles everything
	(:name emacs-goodies-el :type apt-get)))

;; Packages I want installed and updated
(setq my-packages (append '(
	 color-theme
	 color-theme-almost-monokai
	 color-theme-leuven
	 color-theme-solarized
	 org-mode
	 evil
	 el-get
	 )
       ;; Plus everything that is include in el-get-sources
       (mapcar 'el-get-source-name el-get-sources)))

;; Sync my packages!
(el-get 'sync my-packages)

;; }}}
;; Enable modal editing with vim-like behaviour {{{
;; --------------------------------------------------------------------------
(evil-mode 1)

;; }}}
;; Custom set variables, faces {{{
;; --------------------------------------------------------------------------
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(display-time-mode t)
 '(indicate-empty-lines t)
 '(inhibit-startup-screen t)
 '(tool-bar-mode nil))

;; --------------------------------------------------------------------------
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 ; '(default ((t (:family "Ubuntu Mono" :foundry "unknown" :slant normal :weight normal :height 113 :width normal)))))
 '(default ((t (:family "Monaco" :foundry "unknown" :slant normal :weight normal :height 98 :width normal)))))


;; }}}
;; Appearance {{{
;; --------------------------------------------------------------------------
(color-theme-almost-monokai)

;; }}}
;; Org-Mode {{{
;; --------------------------------------------------------------------------
;;
;;
;; Active Babel languages
;; --------------------------------------------------------------------------
(org-babel-do-load-languages 'org-babel-load-languages '(
    (R . t)
    (ditaa . t)
    (python . t)
    (sh . t)
    ))
;; Languages table {{{
;; | Language   | Identifier | Language       | Identifier |
;; |------------+------------+----------------+------------|
;; | Asymptote  | asymptote  | Awk            | awk        |
;; | Emacs Calc | calc       | C              | C          |
;; | C++        | C++        | Clojure        | clojure    |
;; | CSS        | css        | ditaa          | ditaa      |
;; | Graphviz   | dot        | Emacs Lisp     | emacs-lisp |
;; | gnuplot    | gnuplot    | Haskell        | haskell    |
;; | Javascript | js         | LaTeX          | latex      |
;; | Ledger     | ledger     | Lisp           | lisp       |
;; | Lilypond   | lilypond   | MATLAB         | matlab     |
;; | Mscgen     | mscgen     | Objective Caml | ocaml      |
;; | Octave     | octave     | Org-mode       | org        |
;; |            |            | Perl           | perl       |
;; | Plantuml   | plantuml   | Python         | python     |
;; | R          | R          | Ruby           | ruby       |
;; | Sass       | sass       | Scheme         | scheme     |
;; | GNU Screen | screen     | shell          | sh         |
;; | SQL        | sql        | SQLite         | sqlite     |
;; }}}
;;
;;
;; Agenda files
;; --------------------------------------------------------------------------
'(setq org-agenda-files '("~/doc/PKB"))
;;
;;
;; Image resizing
;; --------------------------------------------------------------------------
;; if there is a #+ATTR.*: width="200", resize to 200, otherwise don't resize
(setq org-image-actual-width nil)
;;
;;
;; Fontify code in code blocks
;; --------------------------------------------------------------------------
(setq org-src-fontify-natively t)
;;
;;
;; Key bindings
;; --------------------------------------------------------------------------
;; The four Org commands org-store-link, org-capture, org-agenda, and
;; org-iswitchb should be accessible through global keys (i.e. anywhere in
;; Emacs, not just in Org buffers).
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

(add-hook 'org-mode-hook
          (lambda ()
            (color-theme-leuven)
            ))

;; }}}
;; Funniest part of the file {{{
;; --------------------------------------------------------------------------
;; A vim modeline :)
;;
;; vim: fdm=marker :
;; }}}
