class CmdHelper

  def self.cmd_options(options)
    cmd = ''
    options.each do |option, value|
      cmd << " -#{option} \"#{value}\""
    end
    cmd
  end

end
