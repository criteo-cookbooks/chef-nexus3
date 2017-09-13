property :instance_name, kind_of: String, name_attribute: true
property :nexus3_user, kind_of: [String, NilClass], default: lazy { node['nexus3']['user'] }
property :nexus3_group, kind_of: [String, NilClass], default: lazy { node['nexus3']['group'] }
# property :nexus3_password, kind_of: [String, NilClass], sensitive: true # Admin password
property :version, kind_of: String, default: lazy { node['nexus3']['version'] }
property :url, kind_of: String, default: lazy { node['nexus3']['url'] }
property :checksum, kind_of: String, default: lazy { node['nexus3']['checksum'] }
property :nexus3_home, kind_of: String, default: lazy { node['nexus3']['home'] }
property :path, kind_of: String, default: lazy { node['nexus3']['path'] }
property :data, kind_of: String, default: lazy { node['nexus3']['data'] }
# Name of service used as property for nexus3_service; can be instance_name or something different
# like version number.
property :service_name, kind_of: String, default: lazy { instance_name }
property :properties_variables, kind_of: Hash, default: lazy { node['nexus3']['properties_variables'] }
property :vmoptions_variables, kind_of: Hash, default: lazy { node['nexus3']['vmoptions_variables'] }

action :install do
  install_dir = ::File.join(new_resource.path, "nexus-#{new_resource.version}")

  user new_resource.nexus3_user do
    comment 'Nexus 3 user'
    home new_resource.nexus3_home
    manage_home false # is linked to install_dir below
    shell '/bin/bash'
  end

  group new_resource.nexus3_group do
    members new_resource.nexus3_user
    append true
  end

  # Install Nexus3 software
  ark "nexus-#{new_resource.version}" do
    action :put
    url download_url
    checksum new_resource.checksum
    path new_resource.path
    owner new_resource.nexus3_user
    group new_resource.nexus3_group
  end

  # Setup directories
  [install_dir, new_resource.data, ::File.join(new_resource.data, 'etc')].each do |dir|
    directory dir do
      recursive true
      owner new_resource.nexus3_user
      group new_resource.nexus3_group
      mode '0755'
    end
  end

  # Install configuration from templates
  template ::File.join(install_dir, 'bin', 'nexus.rc') do
    source 'nexus.rc.erb'
    variables(user: new_resource.nexus3_user)
    mode '0644'
    owner new_resource.nexus3_user
    group new_resource.nexus3_group
    cookbook 'nexus3'
    notifies :restart, "nexus3_service[#{new_resource.service_name}]", :delayed
    notifies :create, 'ruby_block[block until operational]', :delayed
  end

  template ::File.join(install_dir, 'bin', 'nexus.vmoptions') do
    source 'nexus.vmoptions.erb'
    variables(
      new_resource.vmoptions_variables.merge(data: new_resource.data)
    )
    mode '0644'
    owner new_resource.nexus3_user
    group new_resource.nexus3_group
    cookbook 'nexus3'
    notifies :restart, "nexus3_service[#{new_resource.service_name}]", :delayed
    notifies :create, 'ruby_block[block until operational]', :delayed
  end

  template ::File.join(new_resource.data, 'etc', 'nexus.properties') do
    source 'nexus.properties.erb'
    variables new_resource.properties_variables
    mode '0644'
    user new_resource.nexus3_user
    group new_resource.nexus3_group
    cookbook 'nexus3'
    notifies :restart, "nexus3_service[#{new_resource.service_name}]", :delayed
    notifies :create, 'ruby_block[block until operational]', :delayed
  end

  link new_resource.nexus3_home do
    to install_dir
    owner new_resource.nexus3_user
    group new_resource.nexus3_group
  end

  nexus3_service new_resource.service_name.to_s do
    install_dir install_dir
    nexus3_user new_resource.nexus3_user
    nexus3_group new_resource.nexus3_group
    action :enable
  end

  # Allow for Nexus to fully start before moving on.
  ruby_block 'block until operational' do
    block do
      Chef::Log.info "Waiting until Nexus is listening on port #{node['nexus3']['properties_variables']['port']}"
      wait_until_ready!(node['nexus3']['api']['endpoint'], node['nexus3']['api']['wait'])
    end
    action :nothing
  end
end

action_class do
  def download_url
    return new_resource.url unless new_resource.url.nil? || new_resource.url.empty?
    url = 'https://download.sonatype.com/nexus/3/nexus-'
    url << new_resource.version.to_s
    url << if platform?('windows')
             '-win64.zip'
           else
             '-unix.tar.gz'
           end
    url
  end

  include Nexus3::Helper
end
