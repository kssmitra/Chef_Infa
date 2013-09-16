default[:icsmysql][:external_device] =
        if node.platform == "redhat" && node.platform_version.start_with?("6") && node.attribute?("ec2")
#                "xvdl".."xvdp"
#                "xvdl1".."xvdl9"
                "xvdl"
        else
                "sdb"
        end

default[:icsmysql][:datadir_fs] = "ext3"
default[:icsmysql][:data_dir] = "/export/home/mysql"
default[:icsmysql][:package_name] = "mysql-server"

default[:icsmysql][:server_root_password]    = "ics@2012"
default[:icsmysql][:mysqladmin_bin]          = "/usr/bin/mysqladmin"
default[:icsmysql][:mysql_bin]               = "/usr/bin/mysql"

