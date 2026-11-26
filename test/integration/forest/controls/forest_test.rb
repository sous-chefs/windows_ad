# frozen_string_literal: true

control 'forest-forest_test' do
  impact 1.0
  title 'Verify forest forest_test'
  desc 'Check the directory state produced by the integration fixture.'
  # InSpec test for recipe windows_ad_test::setup_forest

  # The InSpec reference, with examples and extensive documentation, can be
  # found at https://www.inspec.io/docs/reference/resources/

  describe command('[ADSI]::Exists("LDAP://contoso.local")') do
    its('stdout') { should include 'True' }
  end
end
