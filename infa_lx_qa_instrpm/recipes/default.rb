#
# Cookbook Name:: infa_lx_qa_instrpm
# Recipe:: default
#
# Copyright 2013, Mitra Kaseebhotla
#
# All rights reserved - Do Not Redistribute
#

# 1. Mount the NFS location of the infainstaller
script "mount_nfs_installer_location" do
	interpreter "bash"
	user "root"
	cwd "/"
	code <<-EOH
		mkdir -p /nfs/infainstaller
		mount psrdnfs2:/vol/infainstaller /nfs/infainstaller
	EOH
	not_if " /bin/mount | /bin/grep infainstaller "
end

# 2. Copy the installer to /tmp
script "copy_the_installer" do
	interpreter "bash"
	user "root"
	cwd "/tmp"
	code <<-EOH
		cp #{node.infa_lx_qa_instrpm.location}/#{node.infa_lx_qa_instrpm.targzfile} /tmp/
	EOH
end

# 3. unmount the infainstaller
script "unmount_nfs_installer_location" do
	interpreter "bash"
	user "root"
	cwd "/"
	code <<-EOH
		cd /tmp/
		umount -l /nfs/infainstaller
	EOH
end


# 4. gunzip & untar
script "gunzip_untar_installer" do
	interpreter "bash"
	user "root"
	cwd "/tmp"
	code <<-EOH
		tar xzf #{node.infa_lx_qa_instrpm.targzfile} 
	EOH
end


# 5. install the rpm.
script "install_informatica_hadoop_rpm" do
	interpreter "bash"
	user "root"
	cwd "/tmp"
	code <<-EOH
		/bin/rpm -ivh InformaticaHadoop-#{node.infa_lx_qa_instrpm.version}-1.#{node.infa_lx_qa_instrpm.buildnumber}/*.rpm
	EOH
	not_if "rpm -qa | grep InformaticaHadoop"
end
