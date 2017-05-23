# creates script, then deletes it
nexus3_api 'bar' do
  content "repository.createMavenHosted('bar')"
  username 'admin'
  password 'admin123'

  action :create
  retries 10
  retry_delay 10
end

nexus3_api 'bar' do
  content ''
  username 'admin'
  password 'admin123'

  action :delete
  retries 10
  retry_delay 10
end

nexus3_api 'bar again' do
  script_name 'bar'
  content ''
  username 'admin'
  password 'admin123'

  action :delete
  notifies :run, 'ruby_block[fail if bar is deleted again]', :immediately
end

ruby_block 'fail if bar is deleted again' do
  action :nothing
  block { raise 'nexus3_api is not idempotent!' }
end
