# creates or updates 'example' script to repository manager
nexus3_api 'foo' do
  script_name 'foo'
  content "repository.createMavenHosted('foo')"

  action :create
  retries 10
  retry_delay 10
end

nexus3_api 'foo again' do
  script_name 'foo'
  content "repository.createMavenHosted('foo')"

  action :create
  notifies :run, 'ruby_block[fail if foo is created again]', :immediately
end

ruby_block 'fail if foo is created again' do
  action :nothing
  block { raise 'nexus3_api is not idempotent!' }
end
#
# nexus3_api 'foo' do
#   script_name 'foo'
#   content "repository.createMavenHosted('foo')"
#
#   api_client lazy {
#     ::Nexus3::Api.new('http://localhost:8082/service/rest/v1/script/',
#                       'admin',
#                       ::File.read('/usr/local/nexusdata/admin.password'))
#   }
#
#   action :create
# end
