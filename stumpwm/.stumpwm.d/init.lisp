;; -*- lisp -*-

(in-package :stumpwm)

(load "~/quicklisp/setup.lisp")

;; Basics
(set-prefix-key (kbd "s-w"))
(setf *startup-message* NIL)
(setf *suppress-abort-messages* t)
(setf *shell-program* (getenv "SHELL"))

(defvar *message-filters* '("Group dumped" "There is only one frame.")
  "Don't show these messages.")

(defun message (fmt &rest args)
  "Overwritten message function to allow filters"
  (let ((msg-string (apply 'format nil fmt args)))
    (unless (member msg-string *message-filters* :test #'string=)
      (echo-string (current-screen) msg-string))))

;; (set-module-dir
;;  (pathname-as-directory (concat (getenv "HOME") "/stumpwm/contrib")))

(ql:quickload :clx-truetype)

;; Modules
(load-module "ttf-fonts")
(load-module "winner-mode")
(load-module "globalwindows")

(xft:cache-fonts)

;; Looks
(set-font (make-instance 'xft:font
                         :family "Iosevka"
                         :subfamily "Regular"
                         :antialias t
                         :size 11))

(setf *emacs* "emacsclient --create-frame  ~/git/dotfiles/emacs/.emacs.d/init.el")

(setf *message-window-gravity* :center
      *input-window-gravity* :center
      *window-border-style* :thin
      *message-window-padding* 10
      *maxsize-border-width* 0
      *normal-border-width* 0
      *transient-border-width* 0
      stumpwm::*float-window-border* 0
      stumpwm::*float-window-title-height* 3
      *resize-increment* 40
      *mouse-focus-policy* :sloppy)

(set-normal-gravity :center)
(set-maxsize-gravity :center)
(set-transient-gravity :center)

(set-fg-color "#dbdbdb")
(set-bg-color "#32243F")
(set-border-color "#3C3246")
(set-focus-color "#5C3074")
(set-unfocus-color "#39393d")
(set-win-bg-color "#1c101f")
(set-float-focus-color "#fb2874")
(set-float-unfocus-color "#39393d")

(setf *colors* (list "#1c1e1f"      ; 0 black
                     "#ff6a6a"      ; 1 red
                     "#66cd00"      ; 2 green
                     "#ffd700"      ; 3 yellow
                     "#4f94cd"      ; 4 blue
                     "#c6e2ff"      ; 5 magenta
                     "#00cdcd"      ; 6 cyan
                     "#ffffff"))    ; 7 white

(defun run-emacs-command (cmd)
  (run-shell-command (format nil "emacsclient -e ~s" cmd)))

(defun shift-windows-forward (frames win)
  "Exchange windows through cycling frames."
  (when frames
    (let ((frame (car frames)))
      (shift-windows-forward (cdr frames)
                             (stumpwm::frame-window frame))
      (when win
        (stumpwm::pull-window win frame)))))

(defcommand rotate-windows () ()
  (let* ((frames (stumpwm::head-frames (current-group) (current-head)))
         (win (stumpwm::frame-window (car (last frames)))))
    (shift-windows-forward frames win)))

(defcommand windows-left-right () ()
  "Open windows side by side"
  (run-commands "only" "vsplit"))

(defcommand windows-up-down () ()
  "Open windows up and down"
  (run-commands "only" "hsplit"))

(defmacro is? (cls) ()
  `(let ((win (current-window)))
     (if (and win (window-matches-properties-p win :class ,cls))
         t
       nil)))

(defcommand spotify () ()
  (if (is? "Spotify")
      (eval-command "other")
    (run-or-pull "spotify" '(:class "Spotify") T T)))

(defcommand emacs () ()
  (run-shell-command *emacs*))

;; TODO(thiderman): These should be generated by a glorious macro, but
;; my limited lisp hax0r skills does not allow me to create that yet! :'(
(defcommand emacs/move-left () ()
  (if (is? "Emacs")
      (run-shell-command "emacsclient -e '(stumpwm/windmove-left)'")
    (eval-command "move-focus left")))

(defcommand emacs/move-down () () (if (is? "Emacs") (run-shell-command "emacsclient -e '(stumpwm/windmove-down)'") (eval-command "move-focus down")))
(defcommand emacs/move-up () () (if (is? "Emacs") (run-shell-command "emacsclient -e '(stumpwm/windmove-up)'") (eval-command "move-focus up")))
(defcommand emacs/move-right () () (if (is? "Emacs") (run-shell-command "emacsclient -e '(stumpwm/windmove-right)'") (eval-command "move-focus right")))

(defcommand emacs/terminal () ()
  (if (is? "Emacs")
      (run-emacs-command "(th/eshell-here)")
    (run-or-pull "mor" '(:class "URxvt") T T)))

(define-key *top-map* (kbd "s-h") "emacs/move-left")
(define-key *top-map* (kbd "s-j") "emacs/move-down")
(define-key *top-map* (kbd "s-k") "emacs/move-up")
(define-key *top-map* (kbd "s-l") "emacs/move-right")

(defcommand webdev-setup () ()
  ;; TODO: Toggle so that it always puts the web in the main part
  (only)
  (eval-command "next-in-frame")
  (hsplit "5/16")
  (when (not (is? "Emacs"))
    (eval-command "ror-emacs"))
  (move-focus :right))

(defcommand goto-messenger () ()
  (banish)
  (if (string= (group-name (current-group)) "social")
      (gother)
    (progn
      (gnew "social")
      (move-focus :right))))

(define-key *top-map* (kbd "s-n") "next-in-frame")
(define-key *top-map* (kbd "s-p") "prev-in-frame")
(define-key *top-map* (kbd "s-TAB") "next-in-frame")
(define-key *top-map* (kbd "s-S-TAB") "prev-in-frame")

(define-key *top-map* (kbd "C-s-h") "gprev")
(define-key *top-map* (kbd "C-s-l") "gnext")

(define-key *top-map* (kbd "s-f") "only")

(define-key *top-map* (kbd "s-s") "spotify")
(define-key *top-map* (kbd "s-m") "goto-messenger")
(define-key *top-map* (kbd "s-M-m") "exec chrome-app https://messenger.com")

(define-key *top-map* (kbd "s-r") "rotate-windows")
;; (define-key *top-map* (kbd "s-v") "windows-left-right")
;; (define-key *top-map* (kbd "s-h") "windows-up-down")

(define-key *top-map* (kbd "s-DEL") "exec lock2")
(define-key *top-map* (kbd "s-RET") "emacs/terminal")
(define-key *top-map* (kbd "s-M-C-RET") "exec urxvt")
(define-key *top-map* (kbd "s-SPC") "grouplist")

(define-key *root-map* (kbd "b") "windowlist")
(define-key *root-map* (kbd "w") "gselect")

(define-key *groups-map* (kbd "Right") "gnext")
(define-key *groups-map* (kbd "Left") "gprev")
(define-key *groups-map* (kbd "M-Right") "gnext-with-window")
(define-key *groups-map* (kbd "M-Left") "gprev-with-window")
(define-key *groups-map* (kbd "b") "global-windowlist")

(define-key *top-map* (kbd "s-M-h") "resize-direction left")
(define-key *top-map* (kbd "s-M-j") "resize-direction down")
(define-key *top-map* (kbd "s-M-k") "resize-direction up")
(define-key *top-map* (kbd "s-M-l") "resize-direction right")

(define-key *top-map* (kbd "s-H") "move-window left")
(define-key *top-map* (kbd "s-J") "move-window down")
(define-key *top-map* (kbd "s-K") "move-window up")
(define-key *top-map* (kbd "s-L") "move-window right")

(define-key *root-map* (kbd "l") "windowlist")

(define-key *top-map* (kbd "s-C-a") "webdev-setup")

(defvar *winner-map* (make-sparse-keymap))
(define-key *root-map* (kbd "c") '*winner-map*)
(define-key *winner-map* (kbd "Left") "winner-undo")
(define-key *winner-map* (kbd "Right") "winner-redo")

(define-key *root-map* (kbd "d") "gnew dev")

(defcommand ror-web () ()
  (run-or-raise "chromium" '(:class "Chromium") nil nil))
(define-key *top-map* (kbd "s-q") "ror-web")

(defcommand ror-emacs () ()
  (run-or-raise *emacs* '(:class "Emacs") nil nil))
(define-key *top-map* (kbd "s-d") "ror-emacs")
(define-key *top-map* (kbd "s-M-d") "emacs")

(define-key *top-map* (kbd "s-M-RET") "exec browser")

(define-key *top-map* (kbd "s-C-p") "exec ss -s")
(define-key *top-map* (kbd "s-C-M-p") "exec ss")


(setf (group-name (car (screen-groups (current-screen)))) "dev")
(clear-window-placement-rules)

;; Init
(update-color-map (current-screen))
(run-shell-command "dunst")
(run-shell-command "xsetroot -cursor_name left_ptr")
(run-shell-command "xset -b")
(run-shell-command "xrdb ~/.Xresources")
(run-shell-command "$HOME/.local/bin/keyboard-setup")
(run-shell-command "$HOME/.local/bin/wp")


;; Hooks
(add-hook *post-command-hook* (lambda (command)
                                (when (member command winner-mode:*default-commands*)
                                  (winner-mode:dump-group-to-file))))
