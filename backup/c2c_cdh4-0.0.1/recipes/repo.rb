# TODO This needs to actually use the gpg keys... derp.

###case node[:platform]
###when "redhat", "centos", "scientific", "fedora"

###platform_major_version = node[:platform_version].to_i

###  if node[:hadoop][:yum_repo_url]
###  yum_repo_url = node[:hadoop][:yum_repo_url]
### else
### case platform_major_version
### when 5
###      yum_repo_url = "http://archive.cloudera.com/cdh4/redhat/5/x86_64/cdh/#{node[:hadoop][:release]}/
###    when 6
###      yum_repo_url = "http://archive.cloudera.com/cdh4/redhat/6/x86_64/cdh/#{node[:hadoop][:release]}/
###    end
###  end

###  yum_repository "cloudera-cdh3" do
###    name "cloudera-cdh3"
###    description "Cloudera's Hadoop"
###  url yum_repo_url
###    action :add
###  end
###end


## Added by Mitra for CDH4
## This works only with RHEL 6.x 

template "/etc/yum.repos.d/cloudera-cdh4.repo" do
        source "cloudera-cdh4.repo.erb"
        owner "root"
        group "root"
        mode "0644"
end


