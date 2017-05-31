if defined?(ChefSpec)
  def put_ark(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:ark, :put, resource_name)
  end

  def run_nexus3_api(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:nexus3_api, :run, resource_name)
  end

  def create_nexus3_api(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:nexus3_api, :create, resource_name)
  end

  def delete_nexus3_api(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:nexus3_api, :delete, resource_name)
  end

  def list_nexus3_api(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:nexus3_api, :list, resource_name)
  end

  def create_nexus3_repo(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:nexus3_repo, :create, resource_name)
  end

  def delete_nexus3_repo(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:nexus3_repo, :delete, resource_name)
  end
end
