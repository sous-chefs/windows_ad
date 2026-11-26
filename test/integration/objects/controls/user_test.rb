# frozen_string_literal: true

control 'objects-user_test' do
  impact 1.0
  title 'Verify objects user_test'
  desc 'Check the directory state produced by the integration fixture.'
  # InSpec test for recipe windows_ad_test::user

  # The InSpec reference, with examples and extensive documentation, can be
  # found at https://www.inspec.io/docs/reference/resources/

  describe command('(Get-ADUser -Identity \'Jane Doe\').name -eq "Jane Doe"') do
    its('stdout') { should include 'True' }
  end
end
