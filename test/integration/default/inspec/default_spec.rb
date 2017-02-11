require_relative '../../spec_helper'

describe 'windows_ad::default' do
  describe windows_feature('Microsoft-Windows-GroupPolicy-ServerAdminTools-Update') do
    it { should be_installed }
  end

  describe windows_feature('DirectoryServices-DomainController') do
    it { should be_installed }
  end
  if node[:os_version] < '6.2'
    describe windows_feature('NetFx3') do
      it { should be_installed }
    end
  elsif node[:os_version] >= '6.2'
    describe windows_feature('ServerManager-Core-RSAT') do
      it { should be_installed }
    end

    describe windows_feature('ServerManager-Core-RSAT-Role-Tools') do
      it { should be_installed }
    end

    describe windows_feature('RSAT-AD-Tools-Feature') do
      it { should be_installed }
    end

    describe windows_feature('RSAT-ADDS-Tools-Feature') do
      it { should be_installed }
    end

    describe windows_feature('ActiveDirectory-Powershell') do
      it { should be_installed }
    end

    describe windows_feature('DirectoryServices-DomainController-Tools') do
      it { should be_installed }
    end

    describe windows_feature('DirectoryServices-AdministrativeCenter') do
      it { should be_installed }
    end
  else
    it 'does not have a test' do
      skip 'replace this with server 2016 tests'
    end
  end
end
