# InSpec test for recipe windows_ad::default

# The InSpec reference, with examples and extensive documentation, can be
# found at https://www.inspec.io/docs/reference/resources/

describe windows_feature('GPMC', :powershell) do
  it { should be_installed }
end

describe windows_feature('RSAT', :powershell) do
  it { should be_installed }
end

describe windows_feature('RSAT-Role-Tools', :powershell) do
  it { should be_installed }
end

describe windows_feature('RSAT-AD-Tools', :powershell) do
  it { should be_installed }
end

describe windows_feature('RSAT-ADDS-Tools', :powershell) do
  it { should be_installed }
end

describe windows_feature('RSAT-AD-Powershell', :powershell) do
  it { should be_installed }
end

describe windows_feature('RSAT-ADDS-Tools', :powershell) do
  it { should be_installed }
end

describe windows_feature('RSAT-AD-AdminCenter', :powershell) do
  it { should be_installed }
end

describe windows_feature('AD-Domain-Services', :powershell) do
  it { should be_installed }
end
