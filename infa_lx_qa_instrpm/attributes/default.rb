# Installer Location

default[:infa_lx_qa_instrpm][:version] = "9.5.1.HF1"
default[:infa_lx_qa_instrpm][:buildnumber] = "1536"
platformbits   =  kernel['machine']  =~ /x86_64/ ? "linux-x64" : "linux-x86"
default[:infa_lx_qa_instrpm][:location] = "/nfs/infainstaller/installer/#{node.infa_lx_qa_instrpm.version}/build.#{node.infa_lx_qa_instrpm.buildnumber}/linux-x64"
default[:infa_lx_qa_instrpm][:targzfile] = "InformaticaHadoop-#{node.infa_lx_qa_instrpm.version}-1.#{node.infa_lx_qa_instrpm.buildnumber}.x86_64.tar.gz"

