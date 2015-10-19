#
# Author:: Derek Groh (<dgroh@arch.tamu.edu>)
# Cookbook Name:: windows_ad
# Recipe:: join_domain
# 
# Copyright 2013, Texas A&M
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

# This is provided as a sample recipe to get you up and going with the windows_ad cookbook.

#Can only run once, assumes default cookbook vagrantfile is used
if node['os_version'] >= "6.2"
  powershell_script 'set DNS servers to resolve domain name' do
    code "Set-DNSClientServerAddress -interfaceIndex 12 -ServerAddresses \"192.168.56.5\""
  end
else
  service 'dnscache' do
    action :start
  end
  execute 'set DNS server to resolve domain name' do
    command 'netsh interface ip add dns name="Local Area Connection 2" "192.168.56.5" index=1'
  end
end

windows_ad_computer 'contoso.com' do
  action :join
  domain_user 'Administrator'
  domain_pass 'vagrant'
end