# List of nexus3 existing task types. The 'task_type' property must match any of
# these values.
NEXUS3_TASK_TYPES = [
  'repository.docker.gc',
  'repository.docker.upload-purge',
  'repository.cleanup',
  'repository.storage-facet-cleanup',
  'repository.purge-unused',
  'repository.maven.rebuild-metadata',
  'healthcheck',
  'repository.yum.rebuild.metadata',
  'firewall.audit',
  'tasklog.cleanup',
  'repository.maven.publish-dotindex',
  'repository.npm.reindex',
  'create.browse.nodes',
  'blobstore.rebuildComponentDB',
  'repository.maven.remove-snapshots',
  'repository.maven.purge-unused-snapshots',
  'blobstore.compact',
  'repository.maven.unpublish-dotindex',
  'firewall.ignore-patterns',
  'script',
  'rebuild.asset.uploadMetadata',
  'security.purge-api-keys',
  'repository.rebuild-index',
  'db.backup'
].freeze

property :task_name, String, name_property: true
property :task_type, String, equal_to: NEXUS3_TASK_TYPES
property :properties, Hash, default: {}.freeze
property :crontab, String, default: '0 1 * * * ?'.freeze
property :api_client, ::Nexus3::Api, identity: true, default: lazy { ::Nexus3::Api.default(node) }

load_current_value do |desired|
  begin
    config = ::JSON.parse(api_client.run_script('get_task', desired.task_name))
    current_value_does_not_exist! if config.nil?
    ::Chef::Log.debug "Config is: #{config}"
    crontab config.dig('schedule', 'cronExpression') || ''.freeze
    task_type config['.typeId'] || ''.freeze
    config['properties'].nil? || config['properties'].each do |key, value|
      properties[key] = value
    end

  # We rescue here because during the first run, the task will not exist yet, so we let Chef know that
  # the resource has to be created.
  rescue LoadError, ::Nexus3::ApiError => e
    ::Chef::Log.warn "A '#{e.class}' occured: #{e.message}"
    current_value_does_not_exist!
  end
end

action :create do
  init

  converge_if_changed do
    nexus3_api "upsert_task #{new_resource.task_name}" do
      script_name 'upsert_task'
      args name: new_resource.task_name,
           typeId: new_resource.task_type,
           taskProperties: new_resource.properties,
           crontab: new_resource.crontab

      action %i[create run]
      api_client new_resource.api_client

      content ::Nexus3::Scripts.groovy_content('upsert_task', node)
    end
  end
end

action :delete do
  init

  nexus3_api "delete_task #{new_resource.task_name}" do
    action %i[create run]
    script_name 'delete_task'
    args new_resource.task_name

    content ::Nexus3::Scripts.groovy_content('delete_task', node)

    api_client new_resource.api_client

    not_if { current_resource.nil? }
  end
end

action_class do
  def init
    nexus3_api "get_task #{new_resource.task_name}" do
      action :create
      script_name 'get_task'
      args new_resource.task_name
      api_client new_resource.api_client

      content ::Nexus3::Scripts.groovy_content('get_task', node)
    end
  end

  def whyrun_supported?
    true
  end
end
