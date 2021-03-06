(use-package docker
  :bind (("C-x C-d" . docker-containers)
         (:map docker-containers-command-map
               ("i" . docker-images))))
(use-package dockerfile-mode
  :bind (:map dockerfile-mode-map
              ("C-c C-c" . th/docker-compose)))
(use-package docker-tramp)

(defun th/docker-compose ()
  "Run docker compose on the current file"
  (interactive)
  (compile "make docker"))

(provide 'th-docker)
