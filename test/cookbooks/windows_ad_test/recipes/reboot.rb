file 'C:\reboot.txt' do
  notifies :reboot_now, 'reboot[now]', :immediately
end

reboot 'now' do
  action :nothing
  reason 'Cannot continue Chef run without a reboot.'
  delay_mins 1
end

file 'C:\rebootsuccess.txt'
