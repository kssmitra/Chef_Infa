#
# Cookbook Name:: perforce
# Recipe:: default
#
# Copyright 2012, Informatica Corp.
# Author: Mitra Kaseebhotla
#
# All rights reserved - Do Not Redistribute
#
remote_file "/usr/local/bin/p4" do
	source "#{node[:perforce][:url]}"
	mode "0555" 
end
