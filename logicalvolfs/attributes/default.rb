default[:logicalvolfs][:external_devices] =
        if node.platform == "redhat" && node.attribute?("ec2")
                "xvdl".."xvdp"
#                "xvdl1".."xvdl9"
        elsif dmi['system']['manufacturer'] == "HP" && lsb['release'] =~ /^5\./
		"cciss/c0d1".."cciss/c0d9"	
	else
                "sdb".."sdz"
        end

default[:logicalvolfs][:pathaddition]  = lsb['release'] =~ /^5\./ ? "/usr" : ""

