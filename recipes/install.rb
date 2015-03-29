source_uri = node['eventstore']['source_uri'] 

package_filename = UrlHelper.get_filename(source_uri)

group "eventstore" do
    system true
end

user "eventstore" do
    gid "eventstore"
    shell "/bin/bash"
    home node['eventstore']['data_dir']
    system true
end

directory node['eventstore']['config_dir'] do
  owner node['eventstore']['user']
  recursive true
end

remote_file "#{Chef::Config[:file_cache_path]}/#{package_filename}" do
  source source_uri
  not_if { File.exists?("#{Chef::Config[:file_cache_path]}/#{package_filename}") }
end

execute "eventstore_unpack" do
  cwd Chef::Config[:file_cache_path]
  command "mkdir -p #{node['eventstore']['install_dir']} && tar -xvf #{package_filename} -C #{node['eventstore']['install_dir']}"
  action :run
  not_if { File.directory?("#{node['eventstore']['install_dir']}") }
end


template "/etc/init/eventstore.conf" do
    source "upstart/eventstore.conf.erb"
    variables ({
      :logs_dir => node['eventstore']['logs_dir'],
      :data_dir => node['eventstore']['data_dir'],
      :install_dir => node['eventstore']['install_dir'],
      :executable_dir => node['eventstore']['executable_dir'],
      :user => node['eventstore']['user'],
      :config_file => node['eventstore']['config_file']
    })
    notifies :restart, "service[eventstore]"
end

template "#{node['eventstore']['config_file']}" do
    source "config.yaml.erb"
    notifies :restart, "service[eventstore]"
end

service 'eventstore' do
  provider Chef::Provider::Service::Upstart
  supports :status => true, :restart => true
  action :start
end

