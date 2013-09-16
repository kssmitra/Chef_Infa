class Chef
	class Recipe
		def find_repo_server()
			first_2_octets = node.ipaddress[/^\d+\.\d+/]
			repo_servers_info = 	data_bag_item('repos', 'servers')
			return repo_servers_info[first_2_octets]
		end

		def get_checksum(file)
			checksums_info = 	data_bag_item('repos', 'checksums')
			return checksums_info[file]
		end
	end
end
