# Installer Location

default[:infainstaller][:version] = "9.5.1.HF1"
default[:infainstaller][:buildnumber] = "build.1536"
platformbits   =  kernel['machine']  =~ /x86_64/ ? "linux-x64" : "linux-x86"
default[:infainstaller][:location] = "/nfs/infainstaller/installer/#{node.infainstaller.version}/#{node.infainstaller.buildnumber}/linux-x64"
default[:infainstaller][:tarfile] = "950_Server_Installer_linux-x64.tar"

# Install to Location
default[:infainstaller][:installto][:downloadlocation] = 	"/export/home/Informatica/#{node.infainstaller.version}/#{node.infainstaller.buildnumber}/download"
default[:infainstaller][:installto][:location] = 		"/export/home/Informatica/#{node.infainstaller.version}/#{node.infainstaller.buildnumber}"
default[:infainstaller][:installto][:user] = 		"atqa90"
default[:infainstaller][:installto][:group] = 		"qa"


# SilentInput.properties 

default[:infainstaller][:silentinput][:license_key_loc] = "#{node[:infainstaller][:installto][:downloadlocation]}/license.key"
default[:infainstaller][:silentinput][:user_install_dir] = node[:infainstaller][:installto][:location] 
default[:infainstaller][:silentinput][:install_type] = "0"
default[:infainstaller][:silentinput][:https_enabled] = "0"
default[:infainstaller][:silentinput][:default_https_enabled] = "1"
default[:infainstaller][:silentinput][:custom_https_enabled] = "0"
default[:infainstaller][:silentinput][:kstore_psswd] = "mykeystorepassword"
default[:infainstaller][:silentinput][:kstore_file_location] = "c:\keystorefile"
default[:infainstaller][:silentinput][:https_port] = "8443"
default[:infainstaller][:silentinput][:create_domain] = "1"
default[:infainstaller][:silentinput][:join_domain] = "0"
default[:infainstaller][:silentinput][:ssl_enabled] = "false"
default[:infainstaller][:silentinput][:serves_as_gateway] = "0"
default[:infainstaller][:silentinput][:db_type] = "oracle"
default[:infainstaller][:silentinput][:db_uname] = "atqa41"
default[:infainstaller][:silentinput][:db_passwd] = "atqa41"
default[:infainstaller][:silentinput][:sqlserver_schema_name] = ""
default[:infainstaller][:silentinput][:trusted_connection] = "0"
default[:infainstaller][:silentinput][:db2_tablespace] = ""
default[:infainstaller][:silentinput][:db_custom_string_selection] = "0"

default[:infainstaller][:silentinput][:db_servicename] = "QAUST11G"
default[:infainstaller][:silentinput][:db_address] = "kettle:1521"

default[:infainstaller][:silentinput][:advance_jdbc_param] = ""
default[:infainstaller][:silentinput][:db_custom_string] = ""
default[:infainstaller][:silentinput][:domain_name] = "domain_#{node.hostname}"
default[:infainstaller][:silentinput][:domain_host_name] = "#{node.hostname}"
default[:infainstaller][:silentinput][:node_name] = "node_#{node.hostname}"
default[:infainstaller][:silentinput][:domain_port] = "6005"
default[:infainstaller][:silentinput][:domain_user] = "Administrator"
default[:infainstaller][:silentinput][:domain_psswd] = "Administrator"
default[:infainstaller][:silentinput][:domain_cnfrm_psswd] = "Administrator"
default[:infainstaller][:silentinput][:join_node_name] = "NodeName"
default[:infainstaller][:silentinput][:join_host_name] = "DomainHostName"
default[:infainstaller][:silentinput][:join_domain_port] = ""
default[:infainstaller][:silentinput][:advance_port_config] = "0"
default[:infainstaller][:silentinput][:min_port] = ""
default[:infainstaller][:silentinput][:max_port] = ""
default[:infainstaller][:silentinput][:tomcat_port] = ""
default[:infainstaller][:silentinput][:ac_port] = ""
default[:infainstaller][:silentinput][:server_port] = ""
default[:infainstaller][:silentinput][:ac_shutdwn_port] = ""

#  SilentInput_DT.properties
default[:infainstaller][:silentinput_dt][:install_type] = "0"
default[:infainstaller][:silentinput_dt][:user_install_dir] = "#{node.infainstaller.installto.location}" 
default[:infainstaller][:silentinput_dt][:upg_backup_dir] = "/home/informatica/[version]"

