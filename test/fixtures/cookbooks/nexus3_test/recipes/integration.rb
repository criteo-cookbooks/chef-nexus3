nexus3_cleanup_policy 'integration_cleanup_policy' do
  format 'raw'
  criteria lastBlobUpdated: '604800', lastDownloaded: '259200'
end

nexus3_repo 'integration_repo' do
  attributes storage: { blobStoreName: 'default', writePolicy: 'ALLOW_ONCE' }
  repo_type 'rubygems-hosted'
end

nexus3_group 'integration_group' do
  attributes storage: { blobStoreName: 'default', strictContentTypeValidation: true }
  group_type 'rubygems-group'
end

# Use RutAuth because there is low chance that we actually enable it
nexus3_realm 'rutauth-realm' do
  enable true
end

nexus3_role 'integration_role' do
  description 'Role created during integration tests'
  roles []
  privileges []
end

nexus3_task 'integration_task' do
  task_type 'script'
  crontab '0 2 * * * ?'
  properties({ 'language' => 'lang',
               'source' => 'log.info("Hello task");' })
end

nexus3_user 'integration_user' do
  password 'Secret'
  first_name 'integration'
  last_name 'user'
  email 'user@inte.gra.tion'
  roles ['integration_role']
end
