require 'mixlib/shellout'

class CmdHelper

  def self.cmd_options(options)
    cmd = ''
    options.each do |option, value|
      cmd << " -#{option} \"#{value}\""
    end
    cmd
  end

  def self.dn(name, ou, domain)
    containers = [ 'users', 'builtin', 'computers', 'foreignsecurityprincipals', 'managed service accounts' ]
    
    dn = "CN=#{name},"
    unless ou.nil?
      if containers.include? ou.downcase
        dn << "CN=#{ou},"
      else
        dn << ou.split("/").reverse.map! { |k| "OU=#{k}" }.join(",") << ","
      end
    end
    dn << domain.split(".").map! { |k| "DC=#{k}" }.join(",")
  end

  def self.shell_out(cmd, user, pass, domain)
    shellout = Mixlib::ShellOut.new(cmd, user: user, password: pass, domain: domain)
    shellout.run_command
    if shellout.exitstatus != 0
      raise "Failed to execute command.\nSTDOUT: #{shellout.stdout}\nSTDERR: #{shellout.stderr}"
    end
    shellout
  end
end
