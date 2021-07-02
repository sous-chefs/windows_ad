describe file('c:\reboot.txt') do
  it { should exist }
end

describe file('c:\rebootsuccess.txt') do
  it { should exist }
end
