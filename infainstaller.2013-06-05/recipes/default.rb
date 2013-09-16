#
# Cookbook Name:: infainstaller
# Recipe:: default
#
# Copyright 2012, Informatica Corp.
# Author: Mitra Kaseebhotla
#
# All rights reserved - Do Not Redistribute
#

#1. Create the Download to and Install to dirs.
directory node['infainstaller']['installto']['downloadlocation'] do
	mode "0755"
	owner node['infainstaller']['installto']['user']	
	group node['infainstaller']['installto']['group']
	action :create
	recursive true	
end

directory node['infainstaller']['installto']['location'] do
	mode "0755"
	owner node['infainstaller']['installto']['user']	
	group node['infainstaller']['installto']['group']
	action :create
	recursive true	
end

#2. Copy the installer tar file to download to dir. AND untar file the installer file.
execute "cp #{node['infainstaller']['location']}/#{node['infainstaller']['tarfile']} #{node['infainstaller']['installto']['downloadlocation']}" do 
	not_if { File.exists? ("#{node[:infainstaller][:installto][:downloadlocation]}/#{node['infainstaller']['tarfile']}") }
end
script "untar_installer" do
	interpreter "bash"
	user node['infainstaller']['installto']['user']
	cwd node['infainstaller']['installto']['downloadlocation']
	code <<-EOH
		tar xvf #{node[:infainstaller][:installto][:downloadlocation]}/#{node['infainstaller']['tarfile']}
	EOH
	not_if { File.exists? ("#{node[:infainstaller][:installto][:downloadlocation]}/install.sh") }
end


#3. Create the silent installer properties files from templates.
template "#{node[:infainstaller][:installto][:downloadlocation]}/SilentInput.properties" do
	source "SilentInput.properties.erb"
	owner  node['infainstaller']['installto']['user']
	group node['infainstaller']['installto']['group']
	mode "0644"
end

template "#{node[:infainstaller][:installto][:downloadlocation]}/SilentInput_DT.properties" do
	source "SilentInput_DT.properties.erb"
        owner  node['infainstaller']['installto']['user']
        group node['infainstaller']['installto']['group']
        mode "0644"
end

# Copy the License key file

cookbook_file   "#{node[:infainstaller][:installto][:downloadlocation]}/license.key" do
        mode 0755
	owner  node['infainstaller']['installto']['user']
        group node['infainstaller']['installto']['group']
end

#4. Run the silent installer.
script "run_silent_installer" do
	interpreter "bash"
	user node['infainstaller']['installto']['user']
        cwd node['infainstaller']['installto']['downloadlocation']
	code <<-EOH
##		#{node[:infainstaller][:installto][:downloadlocation]}/silentinstall.sh -f #{node[:infainstaller][:installto][:downloadlocation]}/SilentInput.properties 
		/usr/bin/yes Y | #{node[:infainstaller][:installto][:downloadlocation]}/silentinstall.sh  
	EOH
end

#5. Start the Informatica Service.
#script "start_informatica_services" do
#	interpreter "bash"
#	user node['infainstaller']['installto']['user']
#        cwd node['infainstaller']['installto']['location']
#	code <<-EOH
#		#{node[:infainstaller][:installto][:location]}/tomcat/bin/infaservice.sh startup
#	EOH
#end

