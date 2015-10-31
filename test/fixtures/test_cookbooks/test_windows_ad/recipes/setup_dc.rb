%w(AD-Domain-Services RSAT-AD-PowerShell RSAT-AD-Tools RSAT-ADDS RSAT-AD-AdminCenter).each do |feature|
  windows_feature feature do
    all      true
    provider Chef::Provider::WindowsFeaturePowershell
    action :install
  end
end

user = 'Administrator'
pass = 'Password1234###!'
domain = "#{node.hostname[0..3].downcase}.local"

execute "net user \"#{user}\" \"#{pass}\""

windows_ad_domain domain do
  type           'forest'
  safe_mode_pass pass
  domain_pass    pass
  domain_user    user
  action :create
end
