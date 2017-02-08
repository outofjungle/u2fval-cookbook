#
# Cookbook Name:: u2fval
# Recipe:: default
#
# Copyright 2017 Venkat Venkataraju.

# sudo apt-get install python-pip python-dev build-essential
# sudo pip install --upgrade pip
# sudo pip install --upgrade virtualenv
# pip install u2fval
# /etc/yubico/u2fval/u2fval.conf
# u2fval db init
# apt-get install apache2 apache2-utils libapache2-mod-wsgi
# a2enmod auth_digest
# /etc/apache2/conf-available/u2fval.conf
# htdigest -c /etc/yubico/u2fval/clients.htdigest "u2fval" testclient
# u2fval client create testclient -a http://example.com -f http://example.com
# a2enconf u2fval
# service apache2 reload


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

execute 'pip install --upgrade pip'
execute 'pip install --upgrade u2fval'

cookbook_file '/etc/yubico/u2fval/u2fval.conf' do
  source 'u2fval.conf'
  mode '600'
  owner 'root'
  group 'root'
  sensitive true
end

execute 'u2fval db init'
execute 'u2fval client create testclient -a http://example.com -f http://example.com'

execute 'a2enmod auth_digest' do
  notifies :restart, 'service[apache2]'
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
end

service 'apache2' do
  action :nothing
end
