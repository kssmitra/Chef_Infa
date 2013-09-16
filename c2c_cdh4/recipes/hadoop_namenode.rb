#
# Cookbook Name:: cloudera
# Recipe:: hadoop_namenode
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

include_recipe "c2c_cdh4"

chef_conf_dir = "/etc/hadoop/#{node[:hadoop][:conf_dir]}"


package "hadoop-hdfs-namenode"


# TODO http://hadoop-karma.blogspot.com/2011/01/hadoop-cookbook-how-to-configure-hadoop.html
# Turns out this dfs.name.dir can have many dirs split on , - figure this out
# This should also notify an execute for 'hadooop namenode -format' 
# currently Im not sure how to force Y into the above command as it requires interaction.
# Also you can only format namenode once unless you want to whipe  your metadata 
# so this directory needs a check to make sure its just not creating it again and again and triggering the notify

if node.hadoop.hdfs_site.attribute?("dfs.name.dir")
    node[:hadoop][:hdfs_site]['dfs.name.dir'].split(',').each do |name_dir|
        directory name_dir do
          mode 0755
          owner "#{node[:hadoop][:hdfsuser]}"
         group "#{node[:hadoop][:group]}"
          action :create
          recursive true
          #notify the hadoop namenode format execute
        end
        execute "format dfs.name.dir" do
            command "echo 'Y' | hadoop namenode -format"
            user "#{node[:hadoop][:hdfsuser]}"
            environment ({'JAVA_HOME' => node[:java][:java_home], 'name_dir' => name_dir })
            action :run
            only_if "test -z $(ls $name_dir)" , :environment => { 'name_dir' => name_dir }
        end
    end
end

topology = { :options => node[:hadoop][:topology] }

if node.hadoop.hdfs_site.attribute?('topology.script.file.name')
    topology_dir = File.dirname(node[:hadoop][:hdfs_site]['topology.script.file.name'])

    directory topology_dir do
    mode 0755
    owner "#{node[:hadoop][:hdfsuser]}"
   group "#{node[:hadoop][:group]}"
    action :create
    recursive true
    end

    template node[:hadoop][:hdfs_site]['topology.script.file.name'] do
        source "topology.rb.erb"
        mode 0755
        owner "#{node[:hadoop][:hdfsuser]}"
       group "#{node[:hadoop][:group]}"
        action :create
    variables topology 
    end

end

####service "hadoop-#{node[:hadoop][:version]}-namenode" do
service "hadoop-hdfs-namenode" do
  action [ :start, :enable ]
  supports :restart => true, :reload => false, :status => true
  # Chef 0.9.10 syntax for subscriptions don't seem to work CHEF-1994
  subscribes :restart, resources(:template => [ "#{chef_conf_dir}/core-site.xml", "#{chef_conf_dir}/hdfs-site.xml", "#{chef_conf_dir}/hadoop-env.sh" ])

end

execute "make mapreduce dir file system" do
  command "hadoop fs -mkdir #{node["hadoop"]["mapred_site"]["mapred.system.dir"]}"
  user "#{node[:hadoop][:hdfsuser]}"
  environment ({'JAVA_HOME' => node[:java][:java_home]})
  action :run
  not_if "hadoop fs -test -d $system_dir" , :environment => { 'system_dir' => node["hadoop"]["mapred_site"]["mapred.system.dir"] }
end

execute "cmod /mapred dir" do
  command "hadoop fs -chmod 0700 #{node["hadoop"]["mapred_site"]["mapred.system.dir"]}"
  user "#{node[:hadoop][:hdfsuser]}"
  environment ({'JAVA_HOME' => node[:java][:java_home]})
  action :run
end


execute "chown /mapred dir" do
  command "hadoop fs -chown #{node[:hadoop][:mapreduser]} #{node["hadoop"]["mapred_site"]["mapred.system.dir"]}"
  user "#{node[:hadoop][:hdfsuser]}"
  environment ({'JAVA_HOME' => node[:java][:java_home]})
  action :run
end


### Added by Mitra for CDH4 cluster
### 1.  /tmp dir in HDFS
execute "make temp dir in hdfs" do
 # command "hadoop fs -mkdir #{node["hadoop"]["mapred_site"]["mapred.system.dir"]}"
  command "hadoop fs -mkdir #{node["hadoop"]["temp_dir"]}" 
  user "#{node[:hadoop][:hdfsuser]}"
  environment ({'JAVA_HOME' => node[:java][:java_home]})
  action :run
  not_if "hadoop fs -test -d $system_dir" , :environment => { 'system_dir' => node["hadoop"]["temp_dir"] }
end

execute "cmod /tmp dir" do
  command "hadoop fs -chmod -R 1777 #{node["hadoop"]["temp_dir"]}"
  user "#{node[:hadoop][:hdfsuser]}"
  environment ({'JAVA_HOME' => node[:java][:java_home]})
  action :run
end

### 2.  /var/lib/hadoop-hdfs/ in HDFS
execute "make var mapred dirs in hdfs " do
  command "hadoop fs -mkdir #{node["hadoop"]["mapred"]["var_dir"]}/staging"
  user "#{node[:hadoop][:hdfsuser]}"
  environment ({'JAVA_HOME' => node[:java][:java_home]})
  action :run
  not_if "hadoop fs -test -d $system_dir" , :environment => { 'system_dir' => node["hadoop"]["mapred"]["var_dir"]  }
end

execute "cmod /var/lib/hadoop-hdfs/cache/mapred/mapred/staging dir" do
  command "hadoop fs -chmod 1777 #{node["hadoop"]["mapred"]["var_dir"]}/staging"
  user "#{node[:hadoop][:hdfsuser]}"
  environment ({'JAVA_HOME' => node[:java][:java_home]})
  action :run
end

execute "chown /var/lib/hadoop-hdfs/cache/mapred/mapred" do
  command "hadoop fs -chown -R #{node[:hadoop][:mapreduser]} #{node["hadoop"]["mapred"]["var_dir"]}"
  user "#{node[:hadoop][:hdfsuser]}"
  environment ({'JAVA_HOME' => node[:java][:java_home]})
  action :run
end

### 3. /user/cehdp in HDFS

execute "make homedir for cehdp in hdfs " do
  command "hadoop fs -mkdir /user/cehdp"
  user "#{node[:hadoop][:hdfsuser]}"
  environment ({'JAVA_HOME' => node[:java][:java_home]})
  action :run
  not_if "hadoop fs -test -d $system_dir" , :environment => { 'system_dir' => "/user/cehdp"  }
end

execute "chown /user/cehdp" do
  command "hadoop fs -chown cehdp /user/cehdp"
  user "#{node[:hadoop][:hdfsuser]}"
  environment ({'JAVA_HOME' => node[:java][:java_home]})
  action :run
end


