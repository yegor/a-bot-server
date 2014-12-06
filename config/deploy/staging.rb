#  Servers' configuration.
servers_ips("app", "staging").each do |ip|
  server(ip, roles: %w(app db), user: fetch(:user), phoenix: {
    instances: [ 
      {id: "db",  count: 1, roles: %w(dcell db),  ports: {dcell: 10000}}, 
      {id: "app", count: 1, roles: %w(dcell tcp), ports: {dcell: 11000, tcp: 20000}}
    ]
  })
end

#  Configure SSH connection
set :ssh_options, keys: [server_key_path], forward_agent: true