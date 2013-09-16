default[:buildrpms][:list] = [ "make" , "bash", "vsftpd", "vim-X11", "emacs", "gdb", "grep", "mlocate", "sg3_utils", "gcc" ]
default[:buildservices][:list] = [ "vsftpd" ]

if lsb['release'] =~ /^5\./
	default[:buildrpms][:list] << "nedit"
end
