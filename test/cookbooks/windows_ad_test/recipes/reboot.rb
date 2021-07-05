file 'C:\reboot.txt' do
  notifies :reboot_now, 'reboot[now]', :immediately
end

reboot 'now' do
  action :nothing
  reason 'Cannot continue Chef run without a reboot.'
  delay_mins 5
  not_if { ::File.exist?('C:\rebootsuccess.txt') }
end

file 'C:\rebootsuccess.txt'
