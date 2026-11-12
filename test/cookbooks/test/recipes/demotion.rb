# frozen_string_literal: true

# Persist the lifecycle stage across the promotion and demotion reboots.
marker = ::File.join(Chef::Config[:file_cache_path], 'windows-ad-demotion-promoted')
unless ::File.exist?(marker)
  include_recipe 'test::setup_forest'

  file marker do
    content 'The disposable test forest was promoted.'
  end
end

windows_ad_domain 'contoso.local' do
  domain_user 'Administrator'
  domain_pass 'vagrant'
  safe_mode_pass 'Passw0rd'
  local_pass 'Passw0rd'
  restart false
  action :delete
  notifies :reboot_now, 'reboot[demotion]', :immediately
end

reboot 'demotion' do
  action :nothing
  reason 'Finish demoting the disposable test domain controller.'
  delay_mins 1
end
