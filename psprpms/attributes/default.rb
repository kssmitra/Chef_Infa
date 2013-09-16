if lsb["release"] =~ /^5\./
	default[:psprpms][:list] = [ "glibc*","gawk*","sed*","pciutil*","tcl*","expect*","gcc*","cpp*","binutils*","*net-snmp*" ]
else 
	default[:psprpms][:list] = [ "libuuid*i686","libsm*","libstdc*i686","libX*i686","zlib*i686","libSM*i686","*libnl*","*snmp*" ]
end


