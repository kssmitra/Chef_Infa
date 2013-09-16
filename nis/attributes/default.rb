default[:nis][:domain] = "infa"
default[:nis][:servers] = [ "psislnis2.informatica.com","psislnis1.informatica.com","psvislnis3.informatica.com" ]
default[:nis][:service] = "ypbind"
default[:autofs][:service] = "autofs"
default[:autofs][:links] = {
				"/qa2" => "/nfs/qa2",
				"/qa5" => "/nfs/qa5",
				"/qa9" => "/nfs/qa9"
			    }
default[:autofs][:buildserver][:links] = {
				"/devops" => "/nfs/devops"
			    }
