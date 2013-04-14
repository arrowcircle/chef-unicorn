template "#{node['nginx']['dir']}/sites-available/#{node['app_name']}" do
  source "unicorn-site.erb"
  owner "root"
  group "root"
  mode 00644
end

nginx_site node['app_name'] do
  enable node['app_name']
end

template "/etc/init.d/#{node['app_name']}" do
  user "root"
  owner "root"
  source "unicorn-init.erb"
  mode 00755
end

# template "/etc/init.d/sidekiq" do
#   user "root"
#   owner "root"
#   source "sidekiq-init.erb"
#   mode 00755
# end

pre = "/home/#{node['users']['user']}/projects/#{node['app_name']}/shared"
dirs = [
    "/home/#{node['users']['user']}/projects",
    "/home/#{node['users']['user']}/projects/#{node['app_name']}",
    "/home/#{node['users']['user']}/projects/#{node['app_name']}/releases",
    "/home/#{node['users']['user']}/projects/#{node['app_name']}/shared",
    "#{pre}/uploads",
    "#{pre}/torrents",
    "#{pre}/config",
    "#{pre}/log",
    "#{pre}/tmp",
    "#{pre}/pids"
  ]

dirs.each do |dir|
  directory dir do
    owner node['users']['user']
    user node['users']['user']
    group node['users']['user']
    mode 00775
    action :create
  end
end

template "/home/#{node['users']['user']}/projects/#{node['app_name']}/shared/config/unicorn.rb" do
  user node['users']['user']
  owner node['users']['user']
  source "unicorn.rb.erb"
  variables({
    :workers => node["unicorn"]["worker_processes"],
    :timeout => node["unicorn"]["timeout"]
  })
end