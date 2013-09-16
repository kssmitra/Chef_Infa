default[:nb][:version] = "7.0"
default[:nb][:installer] = "NB_#{node.nb.version}_CLIENTS_GA.tar"
default[:nb][:installer_untar] = "NB_#{node.nb.version}_CLIENTS_GA"
default[:nb][:installer_url] = "http://reposerverhostname/repo/installs/nb/#{node.nb.installer}"

if ( node["ipaddress"] =~ /10.1.4/ ) 
	default[:nb][:mediaservers] = [ "psrg28nb01", "psrg28nb02", "psrg28nb03" ]
else
	default[:nb][:mediaservers] = [ "ps23nb01", "ps23nb02", "ps23nb04", "ps23nb05", "ps23nb03", "ps23nb11", "ps28nb13" ]
end

