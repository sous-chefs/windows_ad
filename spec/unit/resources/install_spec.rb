# frozen_string_literal: true

require 'spec_helper'

describe 'windows_ad_install' do
  step_into :windows_ad_install
  platform 'windows', '2022'

  recipe do
    windows_ad_install 'AD DS'
  end

  it 'installs the role, group policy and directory tools with management tools' do
    expect(chef_run).to install_windows_feature('AD DS features')
      .with(feature_name: %w(AD-Domain-Services GPMC RSAT-AD-Tools), install_method: :windows_feature_powershell, management_tools: true, all: true)
  end
end
