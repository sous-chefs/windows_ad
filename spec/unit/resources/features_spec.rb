# frozen_string_literal: true

require 'spec_helper'

describe 'windows_ad_features' do
  step_into :windows_ad_features
  platform 'windows', '2019'

  context 'with default properties' do
    recipe do
      windows_ad_features 'default'
    end

    it { is_expected.to install_windows_ad_features('default') }
    it { is_expected.to install_windows_feature('ActiveDirectory-Powershell').with(all: true) }
    it { is_expected.to install_windows_feature('DirectoryServices-DomainController').with(all: true) }
  end

  context 'with custom feature list' do
    recipe do
      windows_ad_features 'custom' do
        features ['DirectoryServices-DomainController']
        all false
      end
    end

    it { is_expected.to install_windows_feature('DirectoryServices-DomainController').with(all: false) }
  end
end
