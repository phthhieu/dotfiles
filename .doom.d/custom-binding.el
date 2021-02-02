;; To go to previous buffer pretty easy
(defun switch-to-last-buffer ()
  (interactive)
  (switch-to-buffer nil))
(global-set-key (kbd "C-<backspace>") 'switch-to-last-buffer)

;; Easy motion with a single s
(setq avy-all-windows t)
(map! :nv "s" #'evil-avy-goto-char-timer)

(defun w/projectile-file-path ()
  "Retrieve the file path relative to project root.
Returns:
  - A string containing the file path in case of success.
  - `nil' in case the current buffer does not visit a file."
  (when-let (file-name (buffer-file-name))
    (file-relative-name (file-truename file-name) (projectile-project-root))))

(defun w/projectile-copy-file-path ()
  "Copy and show the file path relative to project root."
  (interactive)
  (if-let (file-path (w/projectile-file-path))
      (progn
        (message file-path)
        (kill-new file-path))
    (message "WARNING: Current buffer is not visiting a file!")))

(defun hero/js-spec-file-p ()
  "Check current buffer is a test file or not"
  (s-index-of "__tests__" buffer-file-name))

(defun hero/js-test-file ()
  "Get spec file for current file"
  (let* ((dir-name (file-name-directory buffer-file-name))
          (test-dir-name (concat dir-name "__tests__/")))
    (concat
      test-dir-name
      (file-name-base buffer-file-name)
      ".spec.js")))

(defun hero/js-find-current-spec ()
  "Open spec file for current file"
  (interactive)
  (find-file (hero/js-test-file)))

(defun hero/js-find-current-code ()
  "Open spec file for current file"
  (interactive)
  (let* ((file-name (s-replace-all '((".spec" . "")) (file-name-base buffer-file-name)))
          (code-file-name (concat "../" file-name ".js")))
    (find-file-at-point code-file-name)))

(defun hero/js-toggle-current-test-file ()
  "Toggle current test file and code"
  (interactive)
  (if (hero/js-spec-file-p)
    (hero/js-find-current-code)
    (hero/js-find-current-spec)))

;; More key mappings
(map! :leader
      (:prefix-map ("f" . "file")
       :desc "Yank relative filename" "y"   #'w/projectile-copy-file-path
       :desc "Yank filename"          "Y"   #'+default/yank-buffer-filename
       :desc "Toggle spec/code file"  "t"   #'hero/js-toggle-current-test-file
       )
      )

;; Prodigy evil collection
(map!
  :nv "<f5>"       #'prodigy
  (:after prodigy :map prodigy-mode-map
    "o"         #'prodigy-browse
    "q"         #'quit-window
    "j"         #'prodigy-next
    "k"         #'prodigy-prev
    "gg"        #'prodigy-first
    "G"         #'prodigy-last
    ;; mark
    "m"         #'prodigy-mark
    "*t"        #'prodigy-mark-tag
    "M"         #'prodigy-mark-all
    "u"         #'prodigy-unmark
    "*T"        #'prodigy-unmark-tag
    "U"         #'prodigy-unmark-all
    "s"         #'prodigy-start
    "S"         #'prodigy-stop
    ;; refresh
    "`"         #'prodigy-display-process
    "it"        #'prodigy-add-tag-filter
    "in"        #'prodigy-add-name-filter
    "I"         #'prodigy-clear-filters
    "gr"        #'prodigy-restart
    "gs"        #'prodigy-jump-magit
    "gd"        #'prodigy-jump-file-manager
    "gh"        #'hero/prodigy-jump-stag
    "gj"        #'prodigy-next-with-status
    "gk"        #'prodigy-prev-with-status
    "C-j"       #'prodigy-next-with-status
    "C-k"       #'prodigy-prev-with-status
    "Y"         #'prodigy-copy-cmd)

  (:after prodigy :map prodigy-view-mode-map
    "x" #'prodigy-view-clear-buffer))

;; Terminal
(map!
 :nv "<f6>"       #'multi-vterm-project
 )
