default[:logicalvolfs][:external_devices] =
        if node.platform == "redhat" && node.attribute?("ec2")
                "xvdl".."xvdp"
#                "xvdl1".."xvdl9"
        else
                "sdb".."sdz"
        end
