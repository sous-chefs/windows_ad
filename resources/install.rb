# frozen_string_literal: true

unified_mode true
provides :windows_ad_install

description 'Install the AD DS role and directory administration tools.'

property :features, Array, default: %w(AD-Domain-Services GPMC RSAT-AD-Tools)

action :install do
  windows_feature 'AD DS features' do
    feature_name new_resource.features
    install_method :windows_feature_powershell
    management_tools true
    all true
    action :install
  end
end
