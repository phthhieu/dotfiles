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
    :name "Report board"
    :command "yarn"
    :args '("demo")
    :cwd "~/Documents/workspace/EH/report-board"
    :tags '(yarn)
    :stop-signal 'int
    :kill-process-buffer-on-stop t)

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
    :name "HD Documentation"
    :command "yarn"
    :args '("start")
    :cwd "~/Documents/workspace/EH/hero-design"
    :tags '(yarn)
    :stop-signal 'int
    :kill-process-buffer-on-stop t)

  (prodigy-define-service
    :name "Mobile HD Lib"
    :command "yarn"
    :args '("start")
    :cwd "~/Documents/workspace/EH/rn-hero-design"
    :tags '(yarn)
    :stop-signal 'int
    :kill-process-buffer-on-stop t)

  (prodigy-define-service
    :name "Mobile HD Documentation"
    :command "yarn"
    :args '("start")
    :cwd "~/Documents/workspace/EH/rn-hero-design"
    :tags '(yarn)
    :stop-signal 'int
    :kill-process-buffer-on-stop t)
  )
