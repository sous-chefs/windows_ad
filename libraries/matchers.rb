if defined?(ChefSpec)
  ChefSpec.define_matcher :windows_ad_computer
  ChefSpec.define_matcher :windows_ad_contact
  ChefSpec.define_matcher :windows_ad_domain
  ChefSpec.define_matcher :windows_ad_group
  ChefSpec.define_matcher :windows_ad_group_member
  ChefSpec.define_matcher :windows_ad_ou
  ChefSpec.define_matcher :windows_ad_user

  def create_windows_ad_computer(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_ad_computer, :create,
                                            resource_name)
  end

  def modify_windows_ad_computer(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_ad_computer, :modify,
                                            resource_name)
  end

  def move_windows_ad_computer(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_ad_computer, :move,
                                            resource_name)
  end

  def delete_windows_ad_computer(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_ad_computer, :delete,
                                            resource_name)
  end

  def create_windows_ad_contact(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_ad_contact, :create,
                                            resource_name)
  end

  def modify_windows_ad_contact(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_ad_contact, :modify,
                                            resource_name)
  end

  def move_windows_ad_contact(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_ad_contact, :move,
                                            resource_name)
  end

  def delete_windows_ad_contact(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_ad_contact, :delete,
                                            resource_name)
  end

  def create_windows_ad_domain(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_ad_domain, :create,
                                            resource_name)
  end

  def join_windows_ad_domain(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_ad_domain, :join,
                                            resource_name)
  end

  def unjoin_windows_ad_domain(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_ad_domain, :unjoin,
                                            resource_name)
  end

  def delete_windows_ad_domain(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_ad_domain, :delete,
                                            resource_name)
  end

  def create_windows_ad_group(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_ad_group, :create,
                                            resource_name)
  end

  def modify_windows_ad_group(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_ad_group, :modify,
                                            resource_name)
  end

  def move_windows_ad_group(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_ad_group, :move,
                                            resource_name)
  end

  def delete_windows_ad_group(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_ad_group, :delete,
                                            resource_name)
  end

  def add_windows_ad_group_member(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_ad_group_member, :add,
                                            resource_name)
  end

  def remove_windows_ad_group_member(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_ad_group_member, :remove,
                                            resource_name)
  end

  def create_windows_ad_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_ad_user, :create,
                                            resource_name)
  end

  def modify_windows_ad_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_ad_user, :modify,
                                            resource_name)
  end

  def move_windows_ad_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_ad_user, :move,
                                            resource_name)
  end

  def delete_windows_ad_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_ad_user, :delete,
                                            resource_name)
  end
end
