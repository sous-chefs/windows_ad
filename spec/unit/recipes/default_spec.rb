#
# Cookbook Name:: windows_ad
# Spec::default
#
# Copyright (c) 2017 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'windows_ad::default' do
  context 'when all attributes are default, on an unspecified platform' do
    let(:chef_run) { ChefSpec::ServerRunner.new.converge(described_recipe) }

    it 'installs a windows_feature `Microsoft-Windows-GroupPolicy-ServerAdminTools-Update`' do
      expect { chef_run }.to install_windows_feature('Microsoft-Windows-GroupPolicy-ServerAdminTools-Update')
    end
    it 'installs a windows_feature `DirectoryServices-DomainController`' do
      expect { chef_run }.to install_windows_feature('DirectoryServices-DomainController')
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
  context 'when all attributes are default, on a server 2008 platform' do
    let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'windows', version: '2008').converge(described_recipe) }

    it 'installs a windows_feature `NetFx3`' do
      expect { chef_run }.to install_windows_feature('NetFx3')
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end

  context 'when all attributes are default, on a server 2012 platform' do
    let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'windows', version: '2012').converge(described_recipe) }

    it 'installs a windows_feature `ServerManager-Core-RSAT`' do
      expect { chef_run }.to install_windows_feature('ServerManager-Core-RSAT')
    end

    it 'installs a windows_feature `ServerManager-Core-RSAT-Role-Tools`' do
      expect { chef_run }.to install_windows_feature('ServerManager-Core-RSAT-Role-Tools')
    end

    it 'installs a windows_feature `RSAT-AD-Tools-Feature`' do
      expect { chef_run }.to install_windows_feature('RSAT-AD-Tools-Feature')
    end

    it 'installs a windows_feature `RSAT-ADDS-Tools-Feature`' do
      expect { chef_run }.to install_windows_feature('RSAT-ADDS-Tools-Feature')
    end

    it 'installs a windows_feature `ActiveDirectory-Powershell`' do
      expect { chef_run }.to install_windows_feature('ActiveDirectory-Powershell')
    end

    it 'installs a windows_feature `DirectoryServices-DomainController-Tools`' do
      expect { chef_run }.to install_windows_feature('DirectoryServices-DomainController-Tools')
    end

    it 'installs a windows_feature `DirectoryServices-AdministrativeCenter`' do
      expect { chef_run }.to install_windows_feature('DirectoryServices-AdministrativeCenter')
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
