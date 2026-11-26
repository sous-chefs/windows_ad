# frozen_string_literal: true

control 'objects-group_test' do
  impact 1.0
  title 'Verify objects group_test'
  desc 'Check the directory state produced by the integration fixture.'
  # InSpec test for recipe windows_ad_test::group

  # The InSpec reference, with examples and extensive documentation, can be
  # found at https://www.inspec.io/docs/reference/resources/

  describe command('(Get-ADGroup -Identity Group1).name -eq "Group1"') do
    its('stdout') { should include 'True' }
  end

  describe command('(Get-ADGroup -Identity OU-Group).name -eq "OU-Group"') do
    its('stdout') { should include 'True' }
  end
end
