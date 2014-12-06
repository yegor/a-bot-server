#  Servers' configuration.
servers_ips("app", "staging").each do |ip|
  server ip, roles: %w(app db), user: fetch(:user), phoenix: {roles: %w(dcell tcp db), instances: 1, ports: {dcell: 10000, tcp: 20000}}
end

#  Configure SSH connection
set :ssh_options, keys: [server_key_path], forward_agent: true