#
# Cookbook Name:: cloudera
# Attributes:: default
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
#include_attribute "java"

default[:hadoop][:version]                = "0.20"
default[:hadoop][:release]                = "4.1.2"

default[:hadoop][:conf_dir]               = "conf.chef"

default[:hadoop][:namenode_port]          = "54310"
default[:hadoop][:jobtracker_port]        = "54311"
default[:hadoop][:datanode_port]        = "50010"
default[:hadoop][:user] = "hadoop"
default[:hadoop][:group] = "hadoop"
default[:hadoop][:hdfsuser] = "hdfs"
default[:hadoop][:mapreduser] = "mapred"
default[:hadoop][:infauser] = "cehdp"
default[:hadoop][:infagroup] = "cehdp"

# Provide rack info
default[:hadoop][:rackaware][:datacenter] = "default"
default[:hadoop][:rackaware][:rack]       = "rack0"

# Use an alternate yum repo and key
default[:hadoop][:yum_repo_url]           = nil
default[:hadoop][:yum_repo_key_url]       = nil

default[:hadoop][:mapred_site]['mapred.fairscheduler.allocation.file'] = "/etc/hadoop-#{node[:hadoop][:version]}/#{node[:hadoop][:conf_dir]}/fair-scheduler.xml"

default[:hadoop][:log4j]['hadoop.root.logger']                                                 = 'INFO,console'
default[:hadoop][:log4j]['hadoop.security.logger']                                             = 'INFO,console'
default[:hadoop][:log4j]['hadoop.log.dir']                                                     = '.'
default[:hadoop][:log4j]['hadoop.log.file']                                                    = 'hadoop.log'
default[:hadoop][:log4j]['hadoop.mapreduce.jobsummary.logger']                                 = '${hadoop.root.logger}'
default[:hadoop][:log4j]['hadoop.mapreduce.jobsummary.log.file']                               = 'hadoop-mapreduce.jobsummary.log'
default[:hadoop][:log4j]['log4j.rootLogger']                                                   = '${hadoop.root.logger}, EventCounter'
default[:hadoop][:log4j]['log4j.threshhold']                                                   = 'ALL'
#default[:hadoop][:log4j]['log4j.appender.DRFA']                                                = 'org.apache.log4j.DailyRollingFileAppender'
#default[:hadoop][:log4j]['log4j.appender.DRFA.File']                                           = '${hadoop.log.dir}/${hadoop.log.file}'
#default[:hadoop][:log4j]['log4j.appender.DRFA.DatePattern']                                    = '.yyyy-MM-dd'
#default[:hadoop][:log4j]['log4j.appender.DRFA.layout']                                         = 'org.apache.log4j.PatternLayout'
#default[:hadoop][:log4j]['log4j.appender.DRFA.layout.ConversionPattern']                       = '%d{ISO8601} %p %c: %m%n'
default[:hadoop][:log4j]['log4j.appender.console']                                             = 'org.apache.log4j.ConsoleAppender'
default[:hadoop][:log4j]['log4j.appender.console.target']                                      = 'System.err'
default[:hadoop][:log4j]['log4j.appender.console.layout']                                      = 'org.apache.log4j.PatternLayout'
default[:hadoop][:log4j]['log4j.appender.console.layout.ConversionPattern']                    = '%d{yy/MM/dd HH:mm:ss} %p %c{2}: %m%n'
default[:hadoop][:log4j]['hadoop.tasklog.taskid']                                              = 'null'
default[:hadoop][:log4j]['hadoop.tasklog.iscleanup']                                           = 'false'
default[:hadoop][:log4j]['hadoop.tasklog.noKeepSplits']                                        = '4'
default[:hadoop][:log4j]['hadoop.tasklog.totalLogFileSize']                                    = '100'
default[:hadoop][:log4j]['hadoop.tasklog.purgeLogSplits']                                      = 'true'
default[:hadoop][:log4j]['hadoop.tasklog.logsRetainHours']                                     = '12'
default[:hadoop][:log4j]['log4j.appender.TLA']                                                 = 'org.apache.hadoop.mapred.TaskLogAppender'
default[:hadoop][:log4j]['log4j.appender.TLA.taskId']                                          = '${hadoop.tasklog.taskid}'
default[:hadoop][:log4j]['log4j.appender.TLA.isCleanup']                                       = '${hadoop.tasklog.iscleanup}'
default[:hadoop][:log4j]['log4j.appender.TLA.totalLogFileSize']                                = '${hadoop.tasklog.totalLogFileSize}'
default[:hadoop][:log4j]['log4j.appender.TLA.layout']                                          = 'org.apache.log4j.PatternLayout'
default[:hadoop][:log4j]['log4j.appender.TLA.layout.ConversionPattern']                        = '%d{ISO8601} %p %c: %m%n'
default[:hadoop][:log4j]['hadoop.security.log.file']                                           = 'SecurityAuth.audit'
default[:hadoop][:log4j]['log4j.appender.DRFAS']                                               = 'org.apache.log4j.DailyRollingFileAppender '
default[:hadoop][:log4j]['log4j.appender.DRFAS.File']                                          = '${hadoop.log.dir}/${hadoop.security.log.file}'
default[:hadoop][:log4j]['log4j.appender.DRFAS.layout']                                        = 'org.apache.log4j.PatternLayout'
default[:hadoop][:log4j]['log4j.appender.DRFAS.layout.ConversionPattern']                      = '%d{ISO8601} %p %c: %m%n'
default[:hadoop][:log4j]['log4j.category.SecurityLogger']                                      = '${hadoop.security.logger}'
default[:hadoop][:log4j]['log4j.logger.org.apache.hadoop.fs.FSNamesystem.audit']               = 'WARN'
default[:hadoop][:log4j]['log4j.logger.org.jets3t.service.impl.rest.httpclient.RestS3Service'] = 'ERROR'
default[:hadoop][:log4j]['log4j.appender.EventCounter']                                        = 'org.apache.hadoop.metrics.jvm.EventCounter'
default[:hadoop][:log4j]['log4j.appender.JSA']                                                 = 'org.apache.log4j.DailyRollingFileAppender'
default[:hadoop][:log4j]['log4j.appender.JSA.File']                                            = '${hadoop.log.dir}/${hadoop.mapreduce.jobsummary.log.file}'
default[:hadoop][:log4j]['log4j.appender.JSA.layout']                                          = 'org.apache.log4j.PatternLayout'
default[:hadoop][:log4j]['log4j.appender.JSA.layout.ConversionPattern']                        = '%d{yy/MM/dd HH:mm:ss} %p %c{2}: %m%n'
default[:hadoop][:log4j]['log4j.appender.JSA.DatePattern']                                     = '.yyyy-MM-dd'
default[:hadoop][:log4j]['log4j.logger.org.apache.hadoop.mapred.JobInProgress$JobSummary']     = '${hadoop.mapreduce.jobsummary.logger}'
default[:hadoop][:log4j]['log4j.additivity.org.apache.hadoop.mapred.JobInProgress$JobSummary'] = 'false'


# Setting for core-site.xml
default["hadoop"]["core_site"]['fs.default.name'] = "hdfs://#{node["ipaddress"]}:#{node[:hadoop][:namenode_port]}"
#default["hadoop"]["core_site"]['fs.checkpoint.dir'] = "/mnt/checkptdir"
default["hadoop"]["core_site"]['fs.checkpoint.dir'] = "/dfs/checkptdir"
default["hadoop"]["core_site"]['topology.script.filename'] = "/etc/hadoop-#{node[:hadoop][:version]}/#{node[:hadoop][:conf_dir]}/rackaware/rascript.sh"

# Setting for hdfs-site.xml
#dfs.name_dir: Comma delimited list of (replicated) paths where the name node stores the namespace and transaction log
#dfs.data.dir: Comma delimited list of paths on the local filesystem of a DataNode where it shouldstore its blocks
default["hadoop"]["hdfs_site"]["dfs.block.size"] = 134217728
#default["hadoop"]["hdfs_site"]["dfs.name.dir"] = '/mnt/services/dfs/namedir'
default["hadoop"]["hdfs_site"]["dfs.name.dir"] = '/dfs/namedir'
default["hadoop"]["hdfs_site"]["dfs.data.dir"] = []
default["hadoop"]["hdfs_site"]["dfs.backup.address"]  = nil
default["hadoop"]["hdfs_site"]["dfs.secondary.http.address"]  = nil
default["hadoop"]["hdfs_site"]["dfs.datanode.address"] = "0.0.0.0:#{node[:hadoop][:datanode_port]}"
default["hadoop"]["hdfs_site"]["dfs.permissions"]  = 'false'
default["hadoop"]["hdfs_site"]["dfs.datanode.max.xcievers"]  = 4096


# Setting for mapred-site.xml

###default["hadoop"]["mapred_site"]["mapred.child.java.opts"] = "-Xmx512M"
default["hadoop"]["mapred_site"]["mapred.child.java.opts"] = "-Xmx2048M"
default["hadoop"]["mapred_site"]["mapred.job.tracker"] = nil
default["hadoop"]["mapred_site"]["mapred.jobtracker.taskScheduler"] = "org.apache.hadoop.mapred.FairScheduler"
default["hadoop"]["mapred_site"]["mapred.fairscheduler.allocation.file"] = nil
default["hadoop"]["mapred_site"]["mapred.tasktracker.map.tasks.maximum"] = 4
default["hadoop"]["mapred_site"]["mapred.tasktracker.reducetasks.maximum"] = 4
default["hadoop"]["mapred_site"]["mapred.system.dir"] = "/mapred/system"
default["hadoop"]["mapred_site"]["mapreduce.jobtracker.restart.recover"] = "true"
default["hadoop"]["mapred_site"]["mapreduce.framework.name"] = "classic"

default["hadoop"]["mapred"]["temp_folder"] = "/tmp/hadoop-mapred/mapred/local"
default["hadoop"]["temp_dir"] = "/tmp"
default["hadoop"]["mapred"]["var_dir"] = "/var/lib/hadoop-hdfs/cache/mapred/mapred"

# Setting for hadoop-env.sh

# Commenting out the following lines for C2C
##default["hadoop"]["logs_mountpoint"] =
###	if node["platform"] == "redhat" && node["platform"]["version"][0] == "6" &&  node.attribute?("ec2")
##if node.platform == "redhat" && node.platform_version.start_with?("6") &&  ! node.ec2.empty?
##		"/dev/xvdj"
##	elsif node.attribute?("ec2")
##		node["ec2"]["block_device_mapping_ephemeral0"]
##	end

#default["hadoop"]["hadoop_env"]["HADOOP_LOG_DIR"] = "/hadooplogs"
#default["hadoop"]["hadoop_env"]["HADOOP_PID_DIR"] = "/hadooplogs/pids"
#default["hadoop"]["hadoop_env"]["HADOOP_LOG_DIR"] = "/var/log/hadoop"
#default["hadoop"]["hadoop_env"]["HADOOP_PID_DIR"] = "/tmp/pids"
##default["hadoop"]["hadoop_env"]["JAVA_HOME"] = "#{node[:java][:java_home]}"
default[:java][:java_home] = "/usr/java/latest"
default["hadoop"]["hadoop_env"]["JAVA_HOME"] = "/usr/java/latest"


# List of potential external volumes. It depends on the cloud provider or Linux kernel, so you may need to add your excpetions or overrides
default[:hadoop][:external_devices] = 
	if node.platform == "redhat" && node.platform_version.start_with?("6") && node.attribute?("ec2")
		"xvdl".."xvdp"
	else
		"sdb".."sdz"
	end

default[:hadoop][:datadir_fs] = "ext3"


