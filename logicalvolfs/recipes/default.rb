#
# Cookbook Name:: logicalvolfs
# Recipe:: default
#
# Copyright 2012, Informatica Corp.
# Author: Mitra Kaseebhotla
#
# All rights reserved - Do Not Redistribute
#
## Added for the Enstratus. Enstratus adds the device but doesnt show that in device list. 
## The solution is to rescan the scsi bus
script "rescan_scsi_bus_script" do
        interpreter "bash"
        user "root"
        cwd "/tmp"
        code <<-EOH
                /usr/bin/rescan-scsi-bus.sh
                /usr/bin/rescan-scsi-bus.sh
                /usr/bin/rescan-scsi-bus.sh
        EOH
end


first_device = node[:logicalvolfs][:external_devices].first
script "create_logicalvol_fs" do
	interpreter "bash"
	user "root"
	cwd "/etc"
	code <<-EOH
		#{node.logicalvolfs.pathaddition}/sbin/pvcreate -f /dev/#{first_device}
		#{node.logicalvolfs.pathaddition}/sbin/vgcreate vgdata /dev/#{first_device}
		totpe=`#{node.logicalvolfs.pathaddition}/sbin/vgdisplay vgdata | /bin/grep "Total" | /bin/awk '{ print $3 }'`
		#{node.logicalvolfs.pathaddition}/sbin/lvcreate -l $totpe -n datavol vgdata
		/sbin/mkfs.ext3 -F /dev/vgdata/datavol
		/bin/echo "/dev/vgdata/datavol  /data                    ext3    defaults        0 2" >> /etc/fstab
		/bin/mkdir -p /data
		/bin/mount /data

		/bin/mkdir /data/home /export
		/bin/ln -s /data/home /export/home
		/bin/mkdir /export/home/builds
		/bin/chown 1854:1128 /export/home/builds		
	EOH

	not_if " /sbin/pvs | /bin/grep /dev/#{first_device} "
end
