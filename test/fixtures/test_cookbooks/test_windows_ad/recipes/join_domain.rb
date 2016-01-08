user = 'Administrator'
pass = 'Passw0rd'
domain = "contoso.local"
# dc_ip  = node['windows_ad']['dc_ip'] || search(:node, "recipe:test_windows_ad\\:\\:setup_dc")[0]['ipaddress']

# puts "DEBUG:: IP => #{dc_ip}"

WindowsHelper.nic_interface_indexes.each do |index|
   powershell_script "set DNS servers for NIC #{index}" do
     code "Set-DNSClientServerAddress -interfaceIndex #{index} -ServerAddresses (\"192.168.1.10\")"
  end
end

execute "net user \"#{user}\" \"#{pass}\""

windows_ad_computer 'doesntmatter' do
 action :join
 domain_name domain
 domain_user user
 domain_pass pass
end

# windows_ad_computer 'stilldnm' do
#  action :unjoin
#  domain_name domain
#  domain_user user
#  domain_pass pass
#  restart true
# end
