# InSpec test for recipe windows_ad::default

# The InSpec reference, with examples and extensive documentation, can be
# found at https://www.inspec.io/docs/reference/resources/

describe windows_feature('GPMC', :dism) do
  it { should be_installed }
end

describe windows_feature('RSAT', :dism) do
  it { should be_installed }
end

describe windows_feature('RSAT-Role-Tools', :dism) do
  it { should be_installed }
end

describe windows_feature('RSAT-AD-Tools', :dism) do
  it { should be_installed }
end

describe windows_feature('RSAT-ADDS-Tools', :dism) do
  it { should be_installed }
end

describe windows_feature('RSAT-AD-Powershell', :dism) do
  it { should be_installed }
end

describe windows_feature('RSAT-ADDS-Tools', :dism) do
  it { should be_installed }
end

describe windows_feature('RSAT-AD-AdminCenter', :dism) do
  it { should be_installed }
end

describe windows_feature('AD-Domain-Services', :dism) do
  it { should be_installed }
end
