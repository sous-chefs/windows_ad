%w(RSAT-AD-PowerShell RSAT-AD-Tools RSAT-ADDS RSAT-AD-AdminCenter).each do |feature|
  windows_feature feature do
    all      true
    provider Chef::Provider::WindowsFeaturePowershell
    action :install
  end
end

short_domain = node.hostname[0..3].downcase
domain = "#{short_domain}.local"
dc_ip  = node['windows_ad']['dc_ip'] || search(:node, "recipe:test_windows_ad\\:\\:setup_dc")[0]['ipaddress']

puts "DEBUG:: IP => #{dc_ip}"

WindowsHelper.nic_interface_indexes.each do |index|
  powershell_script "set DNS servers for NIC #{index}" do
    code "Set-DNSClientServerAddress -interfaceIndex #{index} -ServerAddresses (\"#{dc_ip}\",\"8.8.8.8\")"
  end
end

admin = 'Administrator'
admin_pass = 'Password1234###!'

execute "net user \"#{admin}\" \"#{admin_pass}\""

windows_ad_domain domain do
  action :join
  domain_user admin
  domain_pass admin_pass
end

domain_admin = "#{short_domain}\\#{admin}"
execute "net localgroup \"Administrators\" \"#{domain_admin}\" /add" do
  not_if "net localgroup Administrators | grep -i #{admin} | grep -i #{short_domain}"
end

windows_ad_user 'User3' do
  domain_name domain
  ou 'Users'
  options ({
    'pwd' => 'Password5673#'
  })
  cmd_user   admin
  cmd_pass   admin_pass
  cmd_domain short_domain
  action :create
end
