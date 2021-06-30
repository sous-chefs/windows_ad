user = 'Administrator'
pass = 'Passw0rd'
domain = 'contoso.local'

# Set a complex password to allow creating a domain/forest
execute "net user \"#{user}\" \"#{pass}\""

windows_ad_join 'localhost' do
  action :join
  domain_name domain
  domain_user user
  domain_pass pass
  reboot :immediate
  reboot_delay 60
end
