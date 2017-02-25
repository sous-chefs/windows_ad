# Tests for Windows Server all Families
if os[:family] == 'windows'
  describe os[:family] do
    it { should eq 'windows' }
  end

  describe windows_feature('GPMC') do
    it { should be_installed }
  end

  describe windows_feature('AD-Domain-Services') do
    it { should be_installed }
  end

  # Tests for Windows Server 2008 Family
  if os[:release] < '6.2'
    describe os[:release] do
      it { should be < '6.2' }
    end
    describe windows_feature('NetFx3') do
      it { should be_installed }
    end
  end

  # Tests for Windows Server 2012 Family
  if os[:release] >= '6.2'
    describe os[:release] do
      it { should be >= '6.2' }
    end
    describe windows_feature('RSAT') do
      it { should be_installed }
    end
    describe windows_feature('RSAT-Role-Tools') do
      it { should be_installed }
    end
    describe windows_feature('RSAT-AD-Tools') do
      it { should be_installed }
    end
    describe windows_feature('RSAT-ADDS-Tools') do
      it { should be_installed }
    end
    describe windows_feature('RSAT-AD-PowerShell') do
      it { should be_installed }
    end
    describe windows_feature('RSAT-ADDS') do
      it { should be_installed }
    end
    describe windows_feature('RSAT-AD-AdminCenter') do
      it { should be_installed }
    end
  end
end
