(use-package exwm)

(server-start)

(setq exwm-workspace-number 10)

;; All buffers created in EXWM mode are named "*EXWM*". You may want to change
;; it in `exwm-update-class-hook' and `exwm-update-title-hook', which are run
;; when a new window class name or title is available. Here's some advice on
;; this subject:
;; + Always use `exwm-workspace-rename-buffer` to avoid naming conflict.
;; + Only renaming buffer in one hook and avoid it in the other. There's no
;;   guarantee on the order in which they are run.
;; + For applications with multiple windows (e.g. GIMP), the class names of all
;;   windows are probably the same. Using window titles for them makes more
;;   sense.
;; + Some application change its title frequently (e.g. browser, terminal).
;;   Its class name may be more suitable for such case.
;; In the following example, we use class names for all windows expect for
;; Java applications and GIMP.
(add-hook 'exwm-update-class-hook
          (lambda ()
            (unless (or (string-prefix-p "sun-awt-X11-" exwm-instance-name)
                        (string= "gimp" exwm-instance-name))
              (exwm-workspace-rename-buffer exwm-class-name))))
(add-hook 'exwm-update-title-hook
          (lambda ()
            (when (or (not exwm-instance-name)
                      (string-prefix-p "sun-awt-X11-" exwm-instance-name)
                      (string= "gimp" exwm-instance-name))
              (exwm-workspace-rename-buffer exwm-title))))

;; `exwm-input-set-key' allows you to set a global key binding (available in
;; any case). Following are a few examples.
;; + We always need a way to go back to line-mode from char-mode
(exwm-input-set-key (kbd "s-r") #'exwm-reset)
;; + Bind a key to switch workspace interactively
(exwm-input-set-key (kbd "s-w") #'exwm-workspace-switch)
;; + Bind "s-0" to "s-9" to switch to the corresponding workspace.
(dotimes (i 10)
  (exwm-input-set-key (kbd (format "s-%d" i))
                      `(lambda ()
                         (interactive)
                         (exwm-workspace-switch-create ,i))))
;; + Application launcher ('M-&' also works if the output buffer does not
;;   bother you). Note that there is no need for processes to be created by
;;   Emacs.
(exwm-input-set-key (kbd "s-SPC")
                    (lambda (command)
                      (interactive (list (read-shell-command "$ ")))
                      (start-process-shell-command command nil command)))

;; + 'slock' is a simple X display locker provided by suckless tools.
(exwm-input-set-key [(super backspace)]
                    (lambda () (interactive) (start-process "" nil "lock")))

;; The following example demonstrates how to set a key binding only available
;; in line mode. It's simply done by first push the prefix key to
;; `exwm-input-prefix-keys' and then add the key sequence to `exwm-mode-map'.
;; The example shorten 'C-c q' to 'C-q'.
(push ?\C-q exwm-input-prefix-keys)
(define-key exwm-mode-map [?\C-q] #'exwm-input-send-next-key)

;; The following example demonstrates how to use simulation keys to mimic the
;; behavior of Emacs. The argument to `exwm-input-set-simulation-keys' is a
;; list of cons cells (SRC . DEST), where SRC is the key sequence you press and
;; DEST is what EXWM actually sends to application. Note that SRC must be a key
;; sequence (of type vector or string), while DEST can also be a single key.
(exwm-input-set-simulation-keys
 '(([?\C-b] . left)
   ([?\C-f] . right)
   ([?\C-p] . up)
   ([?\C-n] . down)
   ([?\C-a] . home)
   ([?\C-e] . end)
   ([?\M-v] . prior)
   ([?\C-v] . next)
   ([?\C-d] . delete)
   ([?\C-k] . (S-end delete))))

;; You can hide the mode-line of floating X windows by uncommenting the
;; following lines
(add-hook 'exwm-floating-setup-hook #'exwm-layout-hide-mode-line)
(add-hook 'exwm-floating-exit-hook #'exwm-layout-show-mode-line)

;; You can hide the minibuffer and echo area when they're not used, by
;; uncommenting the following line
(setq exwm-workspace-minibuffer-position nil)

(if (s-equals? (system-name) "dragonisle")
  (require 'exwm-randr)
  (setq exwm-randr-workspace-output-plist
        '(0 "HDMI-0" 1 "HDMI-0" 2 "HDMI-0" 3 "HDMI-0"
          4 "DP-0"   5 "DP-0"   6 "DP-0"   7 "DP-0"))

  (add-hook 'exwm-randr-screen-change-hook
            (lambda ()
              (start-process-shell-command
               "xrandr" nil "xrandr --output DP-0 --right-of HDMI-0 --auto")))
  (exwm-randr-enable))

;; Do not forget to enable EXWM. It will start by itself when things are ready.
(exwm-enable)

(provide 'th-exwm)