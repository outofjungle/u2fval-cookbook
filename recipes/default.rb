#
# Cookbook Name:: u2fval
# Recipe:: default
#
# Copyright 2017 Venkat Venkataraju.

dependencies = %w(
  python-pip
  python-dev
  build-essential
  apache2
  apache2-utils
  libapache2-mod-wsgi
)

package dependencies  do
  action :upgrade
end

execute 'pip install u2fval' do
  not_if 'pip show u2fval'
end

cookbook_file '/etc/yubico/u2fval/u2fval.conf' do
  source 'u2fval.conf'
  mode '600'
  owner 'root'
  group 'root'
  sensitive true
end

execute 'u2fval db init' do
  not_if do
    File.exist? '/etc/yubico/u2fval/u2fval.db'
  end
end

execute 'u2fval client create testclient -a http://example.com -f http://example.com' do
  not_if 'u2fval client list | grep testclient'
end

execute 'a2enmod auth_digest' do
  notifies :restart, 'service[apache2]'
  not_if do
    File.exist? '/etc/apache2/mods-enabled/auth_digest.load'
  end
end

cookbook_file '/etc/apache2/conf-available/u2fval.conf' do
  source 'apache2-u2fval.conf'
  mode '644'
  owner 'root'
  group 'root'
  sensitive true
  notifies :restart, 'service[apache2]'
end

cookbook_file '/etc/yubico/u2fval/clients.htdigest' do
  source 'clients.htdigest'
  mode '644'
  owner 'root'
  group 'root'
  sensitive true
  notifies :restart, 'service[apache2]'
end

execute 'a2enconf u2fval' do
  notifies :restart, 'service[apache2]'
  not_if do
    File.exist? '/etc/apache2/conf-enabled/u2fval.conf'
  end
end

service 'apache2' do
  action :nothing
end
