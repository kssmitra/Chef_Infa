default[:infa_lx_c2c_mysql][:server] = "MySQL-server-6.0.11-0.glibc23.x86_64.rpm" 
default[:infa_lx_c2c_mysql][:server_installer_url] = "http://reposerverhostname/repo/installs/mysql/#{node.infa_lx_c2c_mysql.server}"
default[:infa_lx_c2c_mysql][:client] = "MySQL-client-6.0.11-0.glibc23.x86_64.rpm" 
default[:infa_lx_c2c_mysql][:client_installer_url] = "http://reposerverhostname/repo/installs/mysql/#{node.infa_lx_c2c_mysql.client}"
