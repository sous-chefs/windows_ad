class CmdHelper

  def self.cmd_options(options)
    cmd = ''
    options.each do |option, value|
      cmd << " -#{option} \"#{value}\""
    end
    cmd
  end

  def self.dn(name, ou, domain)
    dn = "CN=#{name},"
    unless ou.nil?
      if ou.downcase == 'users'
        dn << "CN=#{ou},"
      else
        dn << ou.split("/").reverse.map! { |k| "OU=#{k}" }.join(",") << ","
      end
    end
    dn << domain.split(".").map! { |k| "DC=#{k}" }.join(",")
  end
end
