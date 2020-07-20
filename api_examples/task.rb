nexus3_task 'Docker - Delete unused manifests and images' do
  task_type 'repository.docker.gc'
  task_crontab '0 0 1 * * ?'
  properties {'repositoryName' => 'repository_name'}
end

nexus3_task 'Docker - Delete incomplete uploads' do
  task_type 'repository.docker.upload-purge'
  task_crontab '0 0 1 * * ?'
  properties {'age' => 1234}
end

nexus3_task 'Admin - Cleanup repositories using their associated policies' do
  task_type 'repository.cleanup'
  task_crontab '0 0 1 * * ?'
end

nexus3_task 'Storage facet cleanup' do
  task_type 'repository.storage-facet-cleanup'
  task_crontab '0 0 1 * * ?'
end

nexus3_task 'Repository - Delete unused components' do
  task_type 'repository.docker.upload-purge'
  task_crontab '0 0 1 * * ?'
  properties {'repositoryName' => 'repository_name','lastUsed' => 123}
end

nexus3_task 'Repair - Rebuild Maven repository metadata (maven-metadata.xml)' do
  task_type 'repository.maven.rebuild-metadata'
  task_crontab '0 0 1 * * ?'
  properties {'repositoryName' => 'repository_name',
              'groupId' => 'group',
              'artifactId' => 'artifact',
              'baseVersion' => 'version',
              'rebuildChecksums' => false }
end

nexus3_task 'Check for new report availability' do
  task_type 'healthcheck'
  task_crontab '0 0 1 * * ?'
end

nexus3_task 'Repair - Rebuild Yum repository metadata (repodata)' do
  task_type 'repository.yum.rebuild.metadata'
  task_crontab '0 0 1 * * ?'
  properties {'repositoryName' => 'repository_name',
              'yumMetadataCaching' => false}
end

nexus3_task 'Repository Audit' do
  task_type 'firewall.audit'
  task_crontab '0 0 1 * * ?'
end

nexus3_task 'Task log cleanup' do
  task_type 'tasklog.cleanup'
  task_crontab '0 0 1 * * ?'
end

nexus3_task 'Maven - Publish Maven Indexer files' do
  task_type 'repository.maven.publish-dotindex'
  task_crontab '0 0 1 * * ?'
  properties {'repositoryName' => 'repository_name'}
end

nexus3_task 'Repair - Reconcile npm /-/v1/search metadata' do
  task_type 'repository.npm.reindex'
  task_crontab '0 0 1 * * ?'
  properties {'repositoryName' => 'repository_name'}
end

nexus3_task 'Repair - Rebuild repository browse' do
  task_type 'create.browse.nodes'
    task_crontab '0 0 1 * * ?'
  properties {'repositoryName' => 'repository_name'}
end

nexus3_task 'Repair - Reconcile component database from blob store' do
  task_type 'blobstore.rebuildComponentDB'
  task_crontab '0 0 1 * * ?'
  properties {'blobstoreName' => 'blob_store_name',
              'dryRun' => false,
              'restoreBlobs' => false,
              'undeleteBlobs' => false,
              'integrityCheck' => false}
end

nexus3_task 'Maven - Delete SNAPSHOT' do
  task_type 'repository.maven.remove-snapshots'
  task_crontab '0 0 1 * * ?'
  properties {'repositoryName' => 'repository_name',
              'minimumRetained' => 123,
              'snapshotRetentionDays' => 123,
              'removeIfReleased' => false,
              'gracePeriodInDays' => 123 }
end

nexus3_task 'Maven - Delete unused SNAPSHOT' do
  task_type 'repository.maven.purge-unused-snapshots'
  task_crontab '0 0 1 * * ?'
  properties {'repositoryName' => 'repository_name',
              'lastUsed' => 123}
end

nexus3_task 'Admin - Compact blob store' do
  task_type 'blobstore.compact'
  task_crontab '0 0 1 * * ?'
  properties {'blobstoreName' => 'blob_store_name'}
end

nexus3_task 'Maven - Unpublish Maven Indexer files' do
  task_type 'repository.maven.unpublish-dotindex'
  task_crontab '0 0 1 * * ?'
  properties {'repositoryName' => 'repository_name'}
end

nexus3_task 'Firewall ignore patterns' do
  task_type 'firewall.ignore-patterns'
  task_crontab '0 0 1 * * ?'
end

nexus3_task 'Admin - Execute script' do
  task_type 'script'
  task_crontab '0 0 1 * * ?'
  properties {'language' => 'lang',
              'source' => 'script source'}
end

nexus3_task 'Repair - Reconcile date metadata from blob store' do
  task_type 'rebuild.asset.uploadMetadata'
  task_crontab '0 0 1 * * ?'
end

nexus3_task 'Admin - Delete orphaned API keys' do
  task_type 'security.purge-api-keys'
  task_crontab '0 0 1 * * ?'
end

nexus3_task 'Repair - Rebuild repository search' do
  task_type'repository.rebuild-index'
  task_crontab '0 0 1 * * ?'
  properties {'repositoryName' => 'repository_name'}
end

nexus3_task 'Admin - Export databases for backup' do
  task_type 'db.backup'
  task_crontab '0 0 1 * * ?'
  properties {'location' => 'backup_location'}
end
