default[:ics][:groups] = {
                                        "infaops" => 1501,
                                        "infamon" => 1601
                                }

default[:ics][:users] = {
			 "infaops" => [
                                                "1501",
                                                "infaops",
                                                "/export/home/infaops",
                                                "/bin/bash",
                                                'paJSXPwKwCLE2' ],

                          "infamon" => [
                                                "1601",
                                                "infamon",
                                                "/export/home/infamon",
                                                "/bin/bash",
                                                'pax9CmBlJiMe6' ]
			} 


default[:ics][:external_devices] =
        if node.platform == "redhat" && node.platform_version.start_with?("6") && node.attribute?("ec2")
#                "xvdl".."xvdp"
                "xvdl1".."xvdl9"
        else
                "sdb".."sdz"
        end

default[:ics][:datadir_fs] = "ext3"

default[:ics][:node1][:mountpt] = "/opsshare"
default[:ics][:node2][:mountpt] = "/appshare"
default[:ics][:node3][:mountpt] = "/pcshare"
 
