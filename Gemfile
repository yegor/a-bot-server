source "http://rubygems.org"

ruby "2.1.0", engine: "rbx", engine_version: "2.2.10"

gem "foreman"

gem "ffi-rzmq"
gem "ruby-protocol-buffers",  github: "yard/ruby-protocol-buffers"
gem "mysql2celluloid",        github: "yard/mysql2celluloid"

gem "phoenix",                git: "git@github.com:yegor/phoenix.git"

group :development do
  gem "rspec"
  gem "rasem"
  gem "a-bot-cousine",        git: "git@github.com:yegor/a-bot-cousine.git"

  # For local development, please uncomment the follwing lines (but never commit those!)
  # gem "phoenix",              path: "lib/phoenix"
  # gem "a-bot-cousine",        path: "lib/a-bot-cousine"
end