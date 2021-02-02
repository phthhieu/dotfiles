;;; eh/prodigy.el -*- lexical-binding: t; -*-

(after! prodigy
  (prodigy-define-tag
    :name 'puma
    :ready-message "* Listening on tcp://localhost:[0-9]+")

  (prodigy-define-tag
    :name 'yarn
    :ready-message "Note that the development build is not optimized")

  (prodigy-define-tag
    :name 'npm
    :ready-message "Running npm script")

  (prodigy-define-tag
    :name 'grpc
    :ready-message "gRPC Server .+ started")

  (prodigy-define-tag
    :name 'docker-compose
    :ready-message "Docker compose")

  (prodigy-define-tag
    :name 'sh
    :ready-message "sh")

  (prodigy-define-service
    :name "Frontend Core"
    :command "yarn"
    :args '("start")
    :cwd "~/Documents/workspace/EH/frontend-core"
    :tags '(yarn)
    :stop-signal 'int
    :kill-process-buffer-on-stop t)

  (prodigy-define-service
    :name "Employment Hero Server"
    :command "bundle"
    :args '("exec" "rails" "server")
    :cwd "~/Documents/workspace/EH/employment-hero"
    :tags '(puma)
    :stop-signal 'int
    :kill-process-buffer-on-stop t)

  (prodigy-define-service
    :name "Auth gRPC"
    :command "bundle"
    :args '("exec" "eh_protobuf" "start" "-c" "./config/environment.rb")
    :cwd "~/Documents/workspace/EH/auth"
    :tags '(grpc)
    :stop-signal 'int
    :kill-process-buffer-on-stop t)

  (prodigy-define-service
    :name "Comment Service"
    :command "bundle"
    :args '("exec" "rails" "server" "-p" "1516")
    :cwd "~/Documents/workspace/EH/comment"
    :tags '(puma)
    :stop-signal 'int
    :kill-process-buffer-on-stop t)

  (prodigy-define-service
    :name "Re Tailwind"
    :command "npm"
    :args '("run" "dev")
    :cwd "~/Documents/workspace/EH/re-tailwind"
    :tags '(npm reasonml)
    :stop-signal 'int
    :kill-process-buffer-on-stop t)

  (prodigy-define-service
    :name "Pdf Editor"
    :command "npm"
    :args '("run" "dev")
    :cwd "~/Documents/workspace/EH/pdf-editor"
    :tags '(npm reasonml)
    :stop-signal 'int
    :kill-process-buffer-on-stop t)

  (prodigy-define-service
    :name "HD Playground"
    :command "yarn"
    :args '("playground:dev")
    :cwd "~/Documents/workspace/EH/hero-design"
    :tags '(yarn)
    :stop-signal 'int
    :kill-process-buffer-on-stop t)

  (prodigy-define-service
    :name "HD Documentation"
    :command "yarn"
    :args '("documentation:dev")
    :cwd "~/Documents/workspace/EH/hero-design"
    :tags '(yarn)
    :stop-signal 'int
    :kill-process-buffer-on-stop t)
  )
