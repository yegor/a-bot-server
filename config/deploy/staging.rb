#  Servers' configuration.
servers_ips("app", "staging").each do |ip|
  server(ip, roles: %w(app db), user: fetch(:user), phoenix: {
    instances: [ 
      {id: "db",  count: 1, roles: %w(dcell db),  ports: {dcell: 10000}}, 
      {id: "manager", count: 1, roles: %w(dcell tcp login match_maker), ports: {dcell: 11000, tcp: 20000}},
      {id: "app", count: 3, roles: %w(dcell tcp), ports: {dcell: 12000, tcp: 30000}}
    ]
  })
end

#  Configure SSH connection
set :ssh_options, keys: [server_key_path], forward_agent: true