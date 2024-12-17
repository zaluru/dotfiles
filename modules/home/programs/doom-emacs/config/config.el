;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "zaluru"
      user-mail-address "zaluru@zaluru.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 12 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "sans" :size 13))

;;; Autothemer for downloading for example catpuccin
(use-package autothemer
  :ensure t)

;;; Catpuccin theme - defaults to mocha
; how to configure themes - https://discourse.doomemacs.org/t/how-to-switch-customize-or-write-themes/37
;
(setq doom-theme 'doom-tomorrow-night)


;(setq doom-theme 'catppuccin)
;(use-package catppuccin-theme
  ;:config (load-theme 'catppuccin t)
  ;:init (setq catppuccin-flavor 'mocha))
; old
;(setq doom-theme `doom-catppuccin)
; TODO not sure how to set theme properties correctly, need to look up syntax
;(custom-set-faces!
;  `(doom-catppuccin-dark-variant :type "mocha")
;  '(doom-catppuccin-brighter-comments t))

; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/documents/org/")

;; org reveal presentations
(after! org
  (load-library "ox-reveal")
  (setq org-reveal-root "https://cdn.jsdelivr.net/npm/reveal.js"))

;; Astro - framework with which i build my website - does not support org files, but it does support hugo's markdown
; TODO: BROKEN 2024 12 17
;(use-package ox-hugo
;  :ensure t
;  :pin melpa
;  :after ox)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; For editing systemd unit files
(use-package! systemd
  :defer t)

;;TODO irc setup


;;TODO For showing pressed key combination and command used
;(use-package keycast
;  :init
;  (add-to-list 'global-mode-string '("" mode-line-keycast))
;  (keycast-mode))

;; Jump through file, and the line with the cursor will flash
(beacon-mode 1)

;; Here are some additional functions/macros that could help you configure Doom:
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
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
