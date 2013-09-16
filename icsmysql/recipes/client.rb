#
# Cookbook Name:: icsmysql
# Recipe:: client
#
# Copyright 2012, Informatica Corp.
# Author: Mitra Kaseebhotla 
#
# All rights reserved - Do Not Redistribute
#


mysql_packages = [ "mysql" ]
mysql_packages.each do |mysql_pack|
  package mysql_pack do
    action :install
  end
end

