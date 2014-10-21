server:     bundle exec ruby config/application.rb
logcat:     mkdir -p log && touch log/development.log && tail -0f log/development.log
zookeeper:  rm -rf /usr/local/var/run/zookeeper/data/*; if [ $(pgrep -f zoo | wc -l) -gt 0 ]; then kill -9 `pgrep -f zoo`; fi; zkServer start-foreground