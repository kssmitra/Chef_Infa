default[:infaoracle][:version] = "11.2.0.3"
default[:infaoracle][:installer] = "#{node.infaoracle.version}_Linux_x86_Client.zip"
default[:infaoracle][:installer_url] = "http://reposerverhostname/repo/installs/oracle/#{node.infaoracle.installer}" 

default[:infaoracle][:user] = "oracle"
default[:infaoracle][:group] = "dba"
default[:infaoracle][:oraclehomedir] = "/export/home/oracle"
default[:infaoracle][:orainventory] = "#{node.infaoracle.oraclehomedir}/oraInventory"
default[:infaoracle][:product] = "#{node.infaoracle.oraclehomedir}/product/#{node.infaoracle.version}"
