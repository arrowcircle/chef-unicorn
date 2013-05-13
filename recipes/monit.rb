template "/etc/monit/conf.d/#{node['app_name']}" do
  user "root"
  owner "root"
  source "unicorn.monitrc.erb"
end