require 'mixlib/shellout'
# Provides formatting options for cmd
class CmdHelper
  def self.cmd_options(options)
    cmd = ''
    options.each do |option, value|
      cmd << " -#{option} \"#{value}\""
    end
    cmd
  end

  def self.dn(name, ou, domain)
    containers = ['users', 'builtin', 'computers', 'foreignsecurityprincipals',
                  'managed service accounts']
    dn = "CN=#{name},"
    unless ou.nil?
      if containers.include? ou.downcase
        dn << "CN=#{ou},"
      else
        dn << ou_partial_dn(ou) << ','
      end
    end
    dn << dc_partial_dn(domain)
  end

  def self.ou_partial_dn(ou)
    (ou || '').split('/').reverse.map! { |k| "OU=#{k}" }.join(',')
  end

  def self.dc_partial_dn(domain)
    (domain || '').split('.').map! { |k| "DC=#{k}" }.join(',')
  end

  def self.ou_leaf(ou)
    (ou || '').split('/').reverse.first || ''
  end

  def self.shell_out(cmd, user, pass, domain)
    shellout = Mixlib::ShellOut.new(cmd, user: user, password: pass,
                                         domain: domain)
    shellout.run_command
    if shellout.exitstatus != 0
      fail "Failed to execute command.\nSTDOUT: #{shellout.stdout}\nSTDERR:
             #{shellout.stderr}"
    end
    shellout
  end
end
