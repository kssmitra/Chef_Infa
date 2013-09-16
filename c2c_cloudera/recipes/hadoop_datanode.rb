#
# Cookbook Name:: cloudera
# Recipe:: hadoop_datanode
#
# Author:: Cliff Erson (<cerson@me.com>)
# Copyright 2012, Riot Games
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

##include_recipe "cloudera"
include_recipe "c2c_cloudera"

package "hadoop-#{node[:hadoop][:version]}-datanode"

chef_conf_dir = "/etc/hadoop-#{node[:hadoop][:version]}/#{node[:hadoop][:conf_dir]}"

template "/etc/init.d/hadoop-0.20-datanode" do
  mode 0755
  owner "root"
  group "root"
  variables(
    :java_home => node[:java][:java_home]
  )
end

node[:hadoop][:external_devices].each  do |d|
 # puts "Checking /dev/#{d}"
  dfs_index = node[:hadoop][:external_devices].to_a.index(d) + 1
  dfs_dir = "/dfs/#{dfs_index}"
  if node.block_device.has_key?(d) # is the device attached?
    unless node.filesystem.attribute?("/dev/#{d}") && node["hadoop"]["hdfs_site"]["dfs.data.dir"].include?(dfs_dir)
      directory dfs_dir do
        mode 0700
        owner "#{node[:hadoop][:hdfsuser]}"
        group "#{node[:hadoop][:group]}"
        action :create
        recursive true
        notifies :restart, "service[hadoop-#{node[:hadoop][:version]}-datanode]"
      end

    execute "mkfs.#{node.hadoop.datadir_fs} /dev/#{d}" do
      not_if "dumpe2fs -h /dev/#{d} 2>&1"
    end


    mount dfs_dir do
      mount_point dfs_dir
      device "/dev/#{d}"
      fstype node[:hadoop][:datadir_fs]
      action [:mount ,:enable]
    end

##    node.set["hadoop"]["hdfs_site"]["dfs.data.dir"] = node["hadoop"]["hdfs_site"]["dfs.data.dir"].push(dfs_dir)
    node.default["hadoop"]["hdfs_site"]["dfs.data.dir"] = node.default["hadoop"]["hdfs_site"]["dfs.data.dir"].push(dfs_dir)

    # Setting the dif a second time as mount might mess the ownership/permission
    directory dfs_dir do
        mode 0700
        owner "#{node[:hadoop][:hdfsuser]}"
        group "#{node[:hadoop][:group]}"
        action :create
        recursive true
        notifies :restart, "service[hadoop-#{node[:hadoop][:version]}-datanode]"
      end

    directory "#{dfs_dir}/lost+found" do
      owner "#{node[:hadoop][:hdfsuser]}"
      group "#{node[:hadoop][:group]}"
    end

    end

  end


  template "#{chef_conf_dir}/hdfs-site.xml" do
    source "generic-site.xml.erb"
    mode 0644
    owner "#{node[:hadoop][:user]}"
    group "#{node[:hadoop][:group]}"
    action :create
    variables(
      :options =>  node[:hadoop][:hdfs_site]
      )
  end

# node[:hadoop][:hdfs_site]['dfs.data.dir'].split(',').each do |dir|
#   directory dir do
#     mode 0700
#     owner "#{node[:hadoop][:hdfsuser]}"
#    group "#{node[:hadoop][:group]}"
#     action :create
#     recursive true
#     notifies :restart, "service[hadoop-#{node[:hadoop][:version]}-datanode]"
#   end

#   directory "#{dir}/lost+found" do
#     owner "#{node[:hadoop][:hdfsuser]}"
#    group "#{node[:hadoop][:group]}"
#   end
end


service "hadoop-#{node[:hadoop][:version]}-datanode" do
  action [ :start, :enable ]
    supports :restart => true, :reload => false, :status => true
#  subscribes :reload, "template[#{chef_conf_dir}/core-site.xml]"
    subscribes :restart, resources(:template => [ "#{chef_conf_dir}/core-site.xml", "#{chef_conf_dir}/hdfs-site.xml", "#{chef_conf_dir}/hadoop-env.sh" ])
end
