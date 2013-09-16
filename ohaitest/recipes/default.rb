#
# Cookbook Name:: ohaitest
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#




#haa =  ha.select{|k,v| v == 23 }
# haa.each {|ke,va| puts ke }

blockdevs_info = node.block_device.select { |devname,data| data["model"] =~ /disk/ }
blockdevs_names = []
blockdevs_info.each { |devname,data| blockdevs_names.push(devname) }; 
print blockdevs_names.sort;


#Chef::Log.info(blockdevs);

