source "http://rubygems.org"

ruby "2.1.0", engine: "rbx", engine_version: "2.2.10"

gem "rspec"
gem "foreman"

gem "ruby-protocol-buffers",  github: "yard/ruby-protocol-buffers"
gem "mysql2celluloid",        github: "yard/mysql2celluloid"

group :development do
  gem "rasem"
  #gem "phoenix",              path: "lib/phoenix"
  #gem "a-bot-cousine",        path: "../a-bot-cousine"
end

group :production do
  gem "phoenix",              git: "git@github.com:yegor/phoenix.git"
end