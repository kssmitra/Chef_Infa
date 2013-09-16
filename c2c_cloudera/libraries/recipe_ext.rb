class Chef
  module Cloudera
    module RecipeExt

	begin
		require 'socket'
	    require 'timeout'
	rescue LoadError
		Chef::Log.warn("Missing gem socket/timeout'")
	end

	def is_remote_port_open?(remote_host,remote_port,timeout=10)
		Timeout::timeout(timeout) do
			begin
				puts "Checking #{remote_host}:#{remote_port}"
				s=TCPSocket.new remote_host , remote_port
				s.close
			return true
		rescue Errno::ECONNREFUSED , Errno::EHOSTUNREACH
			return false
#		rescue Exception => e
#			puts e.message
		end
		end
		rescue Timeout::Error
#		rescue Exception => e
#			puts e.message
			return false
	end

    def find_cloudera_namenode(environment = nil)

       # if node.run_list.expand(environment).recipes.include?("cloudera:hadoop_namenode")
        if node.recipes.include?("cloudera::hadoop_namenode")
          node
        else
          search_string = "recipes:cloudera\\:\\:hadoop_namenode"
          search_string << " AND chef_environment:#{environment}" if environment
          search(:node, search_string) do |matching_node|
          	puts matching_node.class
			puts matching_node.to_s + " "  + matching_node.ipaddress
          	if is_remote_port_open? matching_node.ipaddress , node.hadoop.namenode_port
          		return matching_node
          	end
          	puts matching_node.to_s + "looks down"
          end
        end
      end

    def find_cloudera_jobtracker(environment = nil)
        if node.recipes.include?("cloudera::hadoop_jobtracker")
          node
        else
          search_string = "recipes:cloudera\\:\\:hadoop_jobtracker"
          search_string << " AND chef_environment:#{environment}" if environment
          search(:node, search_string) do |matching_node|

          	if is_remote_port_open? matching_node.ipaddress , node.hadoop.jobtracker_port
          		return matching_node
          	end
          end
        end
      end

# Don't use function below, search seems to be broken (HTTP Request Returned 400 Bad Request: invalid search query: 'recipes:"cloudera::hadoop_jobtracker"' Parse error at offset: 7 Reason: Expected one of \, " at line 1, column 18 (byte 18) after )
	 def find_cloudera_role(type, environment = nil)
	 	types = {}
	 	types[:namenode] = { :recipe => "cloudera::hadoop_namenode", :port => node.hadoop.namenode_port }
	 	types[:jobtracker] = { :recipe => "cloudera::hadoop_jobtracker", :port => node.hadoop.jobtracker_port }
	 	raise ArgumentError , "I don't know about that kind of hadoop server" unless types.has_key?(type)
        if node.run_list.expand(environment).recipes.include?(types[type][:recipe])
          node
        else
          search_string = %Q(recipes:"#{types[type][:recipe]}")
          search_string << %Q( AND chef_environment:#{environment}) if environment
          search(:node, search_string) do |matching_node|

          	if is_remote_port_open? matching_node.ipaddress , types[type][:port]
          		return matching_node
          	end
          end
        end
      end

    end
  end
end

Chef::Recipe.send(:include, Chef::Cloudera::RecipeExt)
