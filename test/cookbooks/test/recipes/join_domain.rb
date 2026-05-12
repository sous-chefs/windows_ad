# frozen_string_literal: true

user = 'Administrator'
pass = 'Passw0rd'
domain = 'contoso.local'

powershell_script 'Set DNS Server' do
  code 'Set-DnsClientServerAddress -InterfaceAlias "Local Area Connection 2" -serveraddress 192.168.10.10'
end

execute "net user \"#{user}\" \"#{pass}\""

windows_ad_computer 'localhost' do
  action :join
  domain_name domain
  domain_user user
  domain_pass pass
end
