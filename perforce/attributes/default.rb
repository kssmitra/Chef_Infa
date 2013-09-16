
platformbits  = kernel['machine'] =~ /x86_64/ ? "x86_64" : "x86"
default[:perforce][:version] = "r07.3"
default[:perforce][:url] = "http://ftp.perforce.com/perforce/#{node[:perforce][:version]}/bin.linux26#{platformbits}/p4"
