#  Renders ERB template using current binding.
#
def template(from, to, as_root = false)
  template_path = File.expand_path("../templates/#{from}", __FILE__)
  template = ERB.new(File.new(template_path).read).result(binding)
  upload! StringIO.new(template), to
  execute :sudo, :chmod, "644 #{to}"
end

#  Re-renders service folder.
#
def make_service(name, config)
  path = "#{fetch :runit_dir}/sv/#{ name }"
  execute :rm,    "-rf #{path}"
  execute :mkdir, "-p #{path}"

  env = {
    "rvm_path" => "/home/app/.rvm",
    "rvm_ignore_rvmrc" => "1",
    "PHOENIX_ROLES" => config[:roles].join(","),
    "PHOENIX_ENV" => fetch(:stage).to_s,
    "PHOENIX_NODE_CONFIG" => {internal_address: config[:internal_address], internal_port: config[:internal_port], external_address: config[:external_address], external_port: config[:external_port] }.to_json
  }.map { |name, value| "export #{name}=#{ Shellwords.escape(value) }" }.join("\n")

  upload! StringIO.new("#!/bin/bash\nexec 2>&1\n\n#{env}\n\ncd #{ release_path }\nexec ~/.rvm/bin/rvm 2.1.0 exec bundle exec ruby config/application.rb"), "#{path}/run"
  execute :sudo, :chmod, "700 #{path}/run"

  execute :mkdir, "-p #{path}/log"
  upload! StringIO.new("#!/bin/bash\nLOG_FOLDER=#{path}/log\nexec svlogd -tt $LOG_FOLDER"), "#{path}/log/run"
  execute :sudo, :chmod, "700 #{path}/log/run"
end

#  Returns service id for a specific instance.
#
def service_id(instance, index)
  "a-bot-#{ fetch(:stage) }-#{ instance[:id] }-#{ index }"
end

namespace :abot do

  desc "Creates configuration .yml files"
  task :ymls do
    on roles(:app, :db) do
      template "config/database.yml.erb",  "#{shared_path}/config/database.yml"
      template "config/zookeeper.yml.erb", "#{shared_path}/config/zookeeper.yml"
    end
  end

  desc "Creates runit scripts"
  task :services do
    on roles(:app, :db), in: :parallel do |server|
      server.properties.phoenix[:instances].each do |instance|
        instance[:count].times do |i|
          name    = service_id(instance, i)
          config  = {internal_address: server.hostname, external_address: server.hostname, internal_port: instance[:ports][:dcell].to_i + i, external_port: instance[:ports][:tcp].to_i + i, roles: instance[:roles]}

          make_service name, config
        end
      end
    end
  end

  desc "Stops the world"
  task :stop do
    on roles(:app, :db), in: :parallel do |server|
      execute :rm, "-rf #{fetch :runit_dir}/service/*"
    end
  end

  desc "Starts the world"
  task :start do
    on roles(:app, :db), in: :parallel do |server|
      server.properties.phoenix[:instances].each do |instance|
        instance[:count].times do |i|
          name = service_id(instance, i)
          execute :ln, "-s #{fetch :runit_dir}/sv/#{ name } #{fetch :runit_dir}/service/#{ name }"
        end
      end
    end
  end

  desc "Restarts the world"
  task :restart => [:stop, :services, :start]

end