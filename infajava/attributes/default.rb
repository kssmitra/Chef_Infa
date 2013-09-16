default[:java][:version] = "6u33"
platformbits  = kernel['machine'] =~ /x86_64/ ? "x64" : "i586"
default[:java][:installer] = "jdk-#{node.java.version}-linux-#{platformbits}-rpm.bin" 
default[:java][:installer_url] = "http://reposerverhostname/repo/installs/java/#{node.java.installer}"
