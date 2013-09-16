#
# Cookbook Name:: psprpms
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

node[:psprpms][:list].each { |package|

        package "#{package}" do
                action :install
        end
}

