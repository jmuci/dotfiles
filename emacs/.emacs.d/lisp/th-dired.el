(use-package dired
  :ensure nil
  :demand
  :bind (:map dired-mode-map
              ("M-r" . rgrep)
              ("/" . th/dired-goto-root)
              ("~" . th/dired-goto-home)
              ("h" . dired-omit-mode)
              ("e" . th/eshell-here))

  :config
  (add-hook 'dired-mode-hook 'dired-hide-details-mode)

  (setq dired-hide-details-hide-information-lines t)
  (setq-default dired-omit-files-p t)
  (setq dired-hide-details-mode t)
  (setq diredp-hide-details-initially-flag t)
  (setq dired-listing-switches "-alh --group-directories-first")
  (setq dired-recursive-copies 'always)
  (setq dired-recursive-deletes 'always)

  (put 'dired-find-alternate-file 'disabled nil)

  (use-package dired-x
    :ensure nil
    :demand
    :config
    (setq dired-omit-files (concat dired-omit-files "\\|^\\..+$\\|.pyc$\\|.sock$"))
    (setq dired-omit-verbose nil) ;; https://open.spotify.com/track/2XRl0NfORYPEvUJXLtJiND
    (setq dired-omit-mode t))

  (use-package dired-subtree
    :after (dired)))

(defun th/dired-goto-root ()
  "Shortcut to browse to root via dired"
  (interactive)
  (dired "/"))

(defun th/dired-goto-home ()
  "Shortcut to browse to $HOME via dired"
  (interactive)
  (dired "~"))

(provide 'th-dired)
