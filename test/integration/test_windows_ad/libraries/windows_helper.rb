class WindowsHelper
  if RUBY_PLATFORM =~ /mswin|mingw32|windows/
    require 'win32ole'
    @@wmi = WIN32OLE.connect("winmgmts://")
  end

  def self.nic_interface_indexes
    indexes = []
    nics = @@wmi.ExecQuery("Select * from Win32_NetworkAdapter Where NetConnectionStatus = 2")
    nics.each do |nic|
      indexes << nic.interfaceindex
    end
    indexes
  end
end
