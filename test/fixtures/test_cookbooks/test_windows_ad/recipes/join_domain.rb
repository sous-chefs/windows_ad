user = 'Administrator'
pass = 'Passw0rd'
domain = "contoso.local"

powershell_script 'Set DNS Server' do
  case node['os_version']
  when '6.1'
    code 'netsh interface ipv4 add dnsserver localhost 192.168.1.13'
  when '6.2'
    code 'Set-DnsClientServerAddress -InterfaceAlias \"Local Area Connection 2\" -serveraddress 192.168.1.13'
  end
end

execute "net user \"#{user}\" \"#{pass}\""

windows_ad_computer 'localhost' do
 action :join
 domain_name domain
 domain_user user
 domain_pass pass
end
