
default['eventstore']['version'] = '3.0.3'

default['eventstore']['source_uri'] = "https://github.com/EventStore/EventStore/releases/download/oss-v#{node['eventstore']['version']}/EventStore-OSS-Linux-v#{node['eventstore']['version']}.tar.gz"

default['eventstore']['install_dir'] = '/usr/local/eventstore/'
# 2.5.0rc4 had the binaries in a subfolder, this would allow consumer of cookbook to override executable dir if using non-standard archive
default['eventstore']['executable_dir'] = "#{node['eventstore']['install_dir']}EventStore-OSS-Linux-v#{node['eventstore']['version']}/" 
default['eventstore']['user'] = 'eventstore'
default['eventstore']['config_dir'] = '/etc/eventstore/'
default['eventstore']['config_file'] = "#{node['eventstore']['config_dir']}config.yaml"
default['eventstore']['data_dir'] = '/var/lib/eventstore/' 
default['eventstore']['logs_dir'] = '/var/log/eventstore/' 

default['eventstore']['config']['Log'] = node['eventstore']['logs_dir']
default['eventstore']['config']['Db'] = node['eventstore']['data_dir']
default['eventstore']['config']['RunProjections'] = 'ALL'
