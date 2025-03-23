;; NOTE: This is an opinionated config.
;; TODO: Convert to Literate Programming with Org Mode.

;; Disable un-necessary UI elements.
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Adjust font
(set-face-attribute
  :height 175)	      ; fonts in emacs are 1/10 the size defined here.

(load-theme 'wombat)

;; Setup use-package
(setq use-package-always-ensure t)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode t)

;; Disable word wrapping.
(global-visual-line-mode 1)

;; ViM bindings
(use-package evil
  :init
  (setq native-comp-async-report-warnings-errors nil) ; FIXME: Find out why we need to disable some warnings.
  :config
  ;; Sets a keybind which evil-mode will override, allowing us to use emacs modeby default
  (global-set-key (kbd "C-z") 'evil-mode))

;; TODO: When have time, learn these bindings
(setq xah-fly-use-control-key nil)
(use-package xah-fly-keys
  :config
  (xah-fly-keys-set-layout "qwerty")
  (global-set-key (kbd "C-q") 'xah-fly-keys))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(xah-fly-keys evil)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
