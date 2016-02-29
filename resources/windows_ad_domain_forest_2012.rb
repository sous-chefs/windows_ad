
require 'mixlib/shellout'

resource_name :windows_ad_domain_forest_2012

provides :windows_ad_domain, platform: 'windows' do |node|
  node['platform_version'].to_f >= 6.2
end

property :safe_mode_pass, [String, nil], desired_state: false
property :local_pass, [String, nil], desired_state: false
property :options, Hash, default: {}, desired_state: false

action :create do
  if exists?
    new_resource.updated_by_last_action(false)
  else
    cmd = 'Install-ADDSForest'
    cmd << " -DomainName #{new_resource.name}"
    cmd << " -SafeModeAdministratorPassword (convertto-securestring '#{new_resource.safe_mode_pass}' -asplaintext -Force)"
    cmd << ' -Force:$true'

    cmd << format_options(new_resource.options)

    powershell_script "create_domain_#{new_resource.name}" do
      code cmd
      returns [0, 1, 2, 3, 4]
    end

    new_resource.updated_by_last_action(true)
  end
end

action :delete do
  if exists?
    cmd = 'Uninstall-ADDSDomainController'
    cmd << " -LocalAdministratorPassword (ConverTTo-SecureString '#{new_resource.local_pass}' -AsPlainText -Force)"
    cmd << ' -Force:$true'
    cmd << ' -ForceRemoval'
    cmd << ' -DemoteOperationMasterRole' if last_dc?
    cmd << format_options(new_resource.options)

    powershell_script "remove_domain_#{new_resource.name}" do
      code cmd
    end

    new_resource.updated_by_last_action(true)
  else
    new_resource.updated_by_last_action(false)
  end
end

ENUM_NAMES = %w{(Win2003) (Win2008) (Win2008R2) (Win2012) (Win2012R2) (Default)}

action_class.class_eval do

  def exists?
    ldap_path = new_resource.name.split('.').map! { |k| "dc=#{k}" }.join(',')
    check = Mixlib::ShellOut.new("powershell.exe -command [adsi]::Exists('LDAP://#{ldap_path}')").run_command
    check.stdout.match('True')
  end

  def last_dc?
    dsquery = Mixlib::ShellOut.new('dsquery server -forest').run_command
    dsquery.stdout.split("\n").size == 1
  end

  def format_options(options)
    options.reduce('') do |cmd, (option, value)|
      if value.nil?
        cmd << " -#{option}"
      elsif ENUM_NAMES.include?(value) || value.is_a?(Numeric)
        cmd << " -#{option} #{value}"
      else
        cmd << " -#{option} '#{value}'"
      end
    end
  end

end
