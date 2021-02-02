;;; org-mode.el -*- lexical-binding: t; -*-

;; Config org-protocol https://github.com/alphapapa/org-protocol-capture-html#1-add-protocol-handler
(server-start)
(require 'org-protocol)

(defun git-branch-by-title (title link)
  "Auto generate git branch by title"
  (let* ((dashed-title (s-dashed-words title))
          (card-id (car (last (s-split "/" link)))))
    ;; (message "%s/%s--%s"
    ;;   (if (or (s-contains? "refactor" dashed-title)
    ;;         (s-contains? "chore" dashed-title))
    ;;     "chore" "ft")
    (message "%s--%s"
      dashed-title
      card-id)))

(defun add-card-id-to-title (title link)
  "Auto add prefix card it to task name"
  (let ((card-id (car (last (s-split "/" link)))))
    (message "[%s] %s" card-id title)))

(after! org
  (setq evil-org-key-theme '(navigation insert textobjects additional calendar todo))
  (setq org-agenda-files '("~/Dropbox/notes"))
  (require 'org-download)
  (setq org-capture-templates
    `(
       ("n"
         "Notes"
         entry
         (file ,(format-time-string "~/Dropbox/notes/%Y-%m-%d.org" (current-time) t))
         "* TODO %?\n\nCaptured On:%U\n\n%c")
       ("t"
         "Task"
         entry
         (file ,(format-time-string "~/Dropbox/notes/%Y-%m-%d.org" (current-time) t))
         "* TODO %(add-card-id-to-title \"%:initial\" \"%:link\")\n\nGit Branch: %(git-branch-by-title \"%:initial\" \"%:link\")\nSource: %:link\nCaptured On:%U\n\n")
       ))
  )

(after! org-download
  (setq
    org-download-image-org-width 300
    org-download-delete-image-after-download t
    org-download-link-format "[[file:%s]]"
    org-download-method 'directory)
  (if (equal system-type 'darwin)
      (setq org-download-screenshot-method "screencapture -i %s"))
  (setq-default org-download-image-dir "./images"))

(after! org-roam
  (setq org-roam-db-location "~/Dropbox/notes/roam/org-roam.db")
  (setq org-roam-directory "~/Dropbox/notes")
  (setq org-roam-graph-viewer "/usr/bin/open")
  (setq deft-directory "~/Dropbox/notes")
  (setq org-roam-capture-ref-templates
    '(
       ("r" "ref" plain #'org-roam-capture--get-point "" :file-name "${slug}" :head "#+TITLE: ${title}\n#+ROAM_KEY: ${ref}\n" :unnarrowed t)
       ("t" "Employment Hero Task" entry #'org-roam-capture--get-point "%?"
         :file-name "%(format-time-string \"%Y-%m-%d\" (current-time) t)"
         :head "* TODO 11 %(add-card-id-to-title \"${title}\" \"${ref}\")\n\nGit Branch: %(git-branch-by-title \"${title}\" \"${ref}\")\nSource: ${ref}\nCaptured On:%U\n\n"
         :unnarrowed nil)
      ))
  (setq org-roam-dailies-capture-templates
    '(("d" "daily" plain (function org-roam-capture--get-point)
        ""
        :immediate-finish t
        :file-name "%<%Y-%m-%d>"
        :head "#+TITLE: %<%Y-%m-%d>\n#+TODO: TODO IN-PROGRESS IN-REVIEW | DONE\n\n* TODO Check Calendar\n* TODO Check mailbox https://mail.google.com/mail/u/1/#inbox")))
  )

;; Config ob tmux
(after! ob-tmux
  (setq org-babel-default-header-args:tmux
    '((:results . "silent")
       (:session . "default")
       (:socket  . nil)))
  (setq org-babel-tmux-session-prefix "")
  (setq org-babel-tmux-location "/usr/local/bin/tmux"))
