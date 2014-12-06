# Lock capistrano version
lock '3.3.3'

# Load gem-provided extensions
require "capistrano/setup"
require "capistrano/deploy"
require "rvm1/capistrano3"
require "capistrano/bundler"
require "capistrano/a_bot_cousine"

# Load custom tasks
require File.expand_path("../../lib/capistrano/tasks/configure.rb", __FILE__)

# Global configuration
set :application,           "a-bot"
set :repo_url,              "git@github.com:yegor/a-bot-server.git"
set :user,                  "app"
set :deploy_to,             "/home/app/apps/a-bot-#{ fetch(:stage) }"
set :runit_dir,             "/home/app/runit"
set :linked_files,          %w(config/database.yml config/zookeeper.yml)
set :linked_dirs,           %w(tmp log)
set :keep_releases,         5
set :pty,                   true
set :bundle_roles,          %w(app db)
set :bundle_servers,        -> { roles(fetch(:bundle_roles)) }

# RVM configuration
set :rvm1_ruby_version,     "rbx-2.2.10"
set :rvm1_auto_script_path, "/tmp"
set :rvm1_map_bins,         %w{rake gem bundle ruby}

# Hooks in da house
before "bundler:install",   "rvm1:hook"
before "deploy:check",      "abot:ymls"
after  "deploy:check",      "abot:stop"
after  "deploy:published",  "abot:services"
#before "deploy:published",  "abot:start"

