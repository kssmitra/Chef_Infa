#
# Cookbook Name:: cloudera
# Recipe:: default
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

include_recipe "c2c_cdh4::repo"

chef_conf_dir = "/etc/hadoop/#{node[:hadoop][:conf_dir]}"

ohai "reload_passwd" do
  action :nothing
  plugin "passwd"
end


group node[:hadoop][:group] do
#    system true
    action "create"
    notifies :reload, resources(:ohai => "reload_passwd"), :immediately
end

group node[:hadoop][:infagroup] do
#    system true
    action "create"
    notifies :reload, resources(:ohai => "reload_passwd"), :immediately
end

user node[:hadoop][:user]         do
  comment "hadoop User"
  gid "#{node[:hadoop][:group]}"
  home "/home/#{node[:hadoop][:user]}"
  shell "/bin/bash"
  system true
  action "create"
  notifies :reload, resources(:ohai => "reload_passwd"), :immediately
end

user node[:hadoop][:hdfsuser]         do
  comment "hdfs User"
  gid "#{node[:hadoop][:group]}"
  home "/home/#{node[:hadoop][:hdfsuser]}"
  shell "/bin/bash"
  system true
  action "create"
  notifies :reload, resources(:ohai => "reload_passwd"), :immediately
end

user node[:hadoop][:mapreduser]         do
  comment "hdfs User"
  gid "#{node[:hadoop][:group]}"
  home "/home/#{node[:hadoop][:mapreduser]}"
  shell "/bin/bash"
  system true
  action "create"
  notifies :reload, resources(:ohai => "reload_passwd"), :immediately
end

user node[:hadoop][:infauser]         do
  comment "hadoop Infa User"
  gid "#{node[:hadoop][:infagroup]}"
  home "/home/#{node[:hadoop][:infauser]}"
  shell "/bin/bash"
  system true
  action "create"
  notifies :reload, resources(:ohai => "reload_passwd"), :immediately
end

bash "user_mod" do
 user "root"
 cwd "/"
 code <<-EOH
 usermod -p "paYpxS4tG.VuI" #{node[:hadoop][:infauser]}
 echo "cehdp ALL=(ALL)">> /etc/sudoers
 EOH
 not_if "grep cehdp /etc/sudoers"
end



package "hadoop"


# Create some hadoop needed? dirs
# TODO abstract those 2 dirs to attributes
# TODO might not need these
directory "/var/lib/hadoop/tmpdir" do
  mode 0755
  owner "#{node[:hadoop][:user]}"
  group "#{node[:hadoop][:group]}"
  action :create
  recursive true
end

directory "/var/lib/hadoop/mapred" do
  mode 0755
  owner "#{node[:hadoop][:mapreduser]}"
  group "#{node[:hadoop][:group]}"
  action :create
  recursive true
end

directory chef_conf_dir do
  mode 0755
  owner "root"
  group "root"
  action :create
  recursive true
end


nn = find_cloudera_namenode(node.chef_environment)
if nn.class == node.class
	node.set["hadoop"]["core_site"]['fs.default.name']= "hdfs://#{nn.ipaddress}:#{node[:hadoop][:namenode_port]}"
else
	node.set["hadoop"]["core_site"]['fs.default.name']= "hdfs://#{node[:ipaddress]}:#{node[:hadoop][:namenode_port]}"
end

template "#{chef_conf_dir}/core-site.xml" do
  source "generic-site.xml.erb"
  mode 0644
  owner "#{node[:hadoop][:user]}"
  group "#{node[:hadoop][:group]}"
  action :create
  variables(
    :options => node[:hadoop][:core_site]
    )
end

#secondary_namenode = search(:node, "chef_environment:#{node.chef_environment} and recipes:cloudera\\:\\:hadoop_secondary_namenode_server").first

#hdfs_site_vars = { :options => node[:hadoop][:hdfs_site] }
#hdfs_site_vars[:options]['fs.default.name'] = "hdfs://#{namenode[:ipaddress]}:#{node[:hadoop][:namenode_port]}"
# TODO dfs.secondary.http.address should have port made into an attribute - maybe
#hdfs_site_vars[:options]['dfs.secondary.http.address'] = "#{secondary_namenode[:ipaddress]}:50090" if secondary_namenode

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


# if node.hadoop.attribute?("mapred_site")
#     jobtracker = search(:node, "chef_environment:#{node.chef_environment} AND recipes:cloudera\\:\\:hadoop_jobtracker").first
jt = find_cloudera_jobtracker(node.chef_environment)
if jt.class == node.class
	node.set[:hadoop][:mapred_site]['mapred.job.tracker'] = "#{jt.ipaddress}:#{node[:hadoop][:jobtracker_port]}"
else
	node.set[:hadoop][:mapred_site]['mapred.job.tracker'] = "#{node[:ipaddress]}:#{node[:hadoop][:jobtracker_port]}"
end

    # mapred_site_vars = { :options => node[:hadoop][:mapred_site] }
    #mapred_site_vars[:options]['mapred.job.tracker'] = "#{jobtracker[:ipaddress]}:#{node[:hadoop][:jobtracker_port]}" if jobtracker

template "#{chef_conf_dir}/mapred-site.xml" do
	source "generic-site.xml.erb"
	mode 0644
	owner "#{node[:hadoop][:user]}"
	group "#{node[:hadoop][:group]}"
	action :create
	variables  :options =>  node[:hadoop][:mapred_site]
end


template "#{chef_conf_dir}/hadoop-env.sh" do
  mode 0755
  owner "#{node[:hadoop][:user]}"
  group "#{node[:hadoop][:group]}"
  action :create
  variables( :options => node[:hadoop][:hadoop_env] )
end

if node.hadoop.attribute?("fair_scheduler")
    template node[:hadoop][:mapred_site]['mapred.fairscheduler.allocation.file'] do
    mode 0644
    owner "#{node[:hadoop][:user]}"
    group "#{node[:hadoop][:group]}"
    action :create
    variables node[:hadoop][:fair_scheduler]
    end
end

###template "#{chef_conf_dir}/log4j.properties" do
###source "log4j.properties.erb"
###  mode 0644
###  owner "#{node[:hadoop][:user]}"
###  group "#{node[:hadoop][:group]}"
###  action :create
###  variables( :properties => node[:hadoop][:log4j] )
###end

if node.hadoop.attribute?("hadoop_metrics")
    template "#{chef_conf_dir}/hadoop-metrics.properties" do
    source "generic.properties.erb"
    mode 0644
    owner "#{node[:hadoop][:user]}"
    group "#{node[:hadoop][:group]}"
    action :create
    variables( :properties => node[:hadoop][:hadoop_metrics] )
    end
end

# Create the master and slave files
namenode_servers = search(:node, "chef_environment:#{node.chef_environment} AND recipes:c2c_cdh4\\:\\:hadoop_namenode OR recipes:c2c_cdh4\\:\\:hadoop_secondary_namenode")
masters = namenode_servers.map { |node| node[:ipaddress] }
datanode_servers = search(:node, "chef_environment:#{node.chef_environment} AND recipes:c2c_cdh4\\:\\:hadoop_datanode")
slaves = datanode_servers.map { |node| node[:ipaddress] }

template "#{chef_conf_dir}/masters" do
  source "master_slave.erb"
  mode 0644
  owner "#{node[:hadoop][:user]}"
  group "#{node[:hadoop][:group]}"
  action :create
  variables( :nodes => masters )
end


template "#{chef_conf_dir}/slaves" do
  source "master_slave.erb"
  mode 0644
  owner "#{node[:hadoop][:user]}"
  group "#{node[:hadoop][:group]}"
  action :create
  variables( :nodes => slaves )
end

execute "update hadoop alternatives" do
  #command "alternatives --install /etc/hadoop-#{node[:hadoop][:version]}/conf hadoop-#{node[:hadoop][:version]}-conf /etc/hadoop-#{node[:hadoop][:version]}/#{node[:hadoop][:conf_dir]} 50"
  command "alternatives --install /etc/hadoop/conf hadoop-conf /etc/hadoop/#{node[:hadoop][:conf_dir]} 50"
end

