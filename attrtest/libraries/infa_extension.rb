class Chef
  module Informatica_General
    module RecipeExt
	def find_repo_server()
		first_2_octets =~ node.ipaddress[/^\d+\.\d+/]
		repo_servers_info = 	data_bag('repos', 'servers')
		return repo_servers_info[first_2_octets]
	end
    end
  end
end
