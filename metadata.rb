name 'nexus3'
maintainer 'Criteo'
maintainer_email 'sre-core-infra@criteo.com'
license 'MIT'
description 'Installs/Configures Sonatype Nexus 3 Repository Manager'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url 'https://github.com/criteo-cookbooks/chef-nexus3' if respond_to?(:source_url)
issues_url 'https://github.com/criteo-cookbooks/chef-nexus3/issues' if respond_to?(:issues_url)
version '4.0.0'

chef_version '>= 12.14.34'

depends 'ark'
depends 'updatable-attributes'

supports 'centos'
supports 'debian'
supports 'fedora'
supports 'redhat'
supports 'ubuntu'
supports 'windows'
