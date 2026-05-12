# frozen_string_literal: true

title 'windows_ad feature installation'

control 'windows-ad-features-01' do
  impact 1.0
  title 'AD DS features are installed'

  %w(
    GPMC
    RSAT
    RSAT-Role-Tools
    RSAT-AD-Tools
    RSAT-ADDS-Tools
    RSAT-AD-Powershell
    RSAT-AD-AdminCenter
    AD-Domain-Services
  ).each do |feature|
    describe windows_feature(feature, :powershell) do
      it { should be_installed }
    end
  end
end
