#
# Cookbook:: mongo
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.
# apt_update 'update_sources' do
#   action :update
# end


apt_update 'update_sources' do
  action :update
end

apt_repository 'mongodb-org' do
  uri 'http://repo.mongodb.org/apt/ubuntu'
  distribution 'trusty/mongodb-org/3.2'
  components ['multiverse']
  keyserver 'hkp://keyserver.ubuntu.com:80'
  key 'EA312927'
  action :add
  notifies :restart, 'service[mongod]'
end

# directory '/data/' do
#   owner 'root'
#   group 'root'
#   mode '0755'
#   action :create
# end
#
# directory '/data/db/' do
#   owner 'root'
#   group 'root'
#   mode '0755'
#   action :create
# end

template '/etc/mongod.conf' do
  source 'mongod.conf.erb'
  variables(proxy_port: node['mongod']['proxy_port'], proxy_ip: node['mongod']['proxy_ip'])
  mode '0755'
  owner 'root'
  group 'root'
end

template '/etc/systemd/system/mongod.service' do
  source 'mongod.service.erb'
  mode '0600'
  owner 'root'
  group 'root'
end

package 'mongodb-org' do
  options '--allow-unauthenticated'
  action :install
end

service 'mongod' do
  action [:enable, :start]
end
