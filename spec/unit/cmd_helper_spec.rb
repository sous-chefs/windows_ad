require 'spec_helper'
require_relative '../../libraries/cmd_helper'

describe 'cmd_helper' do
  describe '#cmd_options' do
    it 'builds an empty string when there are no options' do
      result = CmdHelper.cmd_options({})

      expect(result).to be_empty
    end

    it 'adds a minus to the options and wrapps the vlaues in double quotes' do
      result = CmdHelper.cmd_options('opt1' => 'val1', 'opt2' => 'val2')

      expect(result).to eq(' -opt1 "val1" -opt2 "val2"')
    end
  end

  describe '#dn' do
    it 'builds a dn with a name, an OU and a domain' do
      result = CmdHelper.dn('name', 'unit', 'domain')

      expect(result).to eq('CN=name,OU=unit,DC=domain')
    end

    it 'splits composit OUs' do
      result = CmdHelper.dn('name', 'unit/subunit', 'domain')

      expect(result).to eq('CN=name,OU=subunit,OU=unit,DC=domain')
    end

    it 'splits composit domain names' do
      result = CmdHelper.dn('name', 'unit', 'domain.local')

      expect(result).to eq('CN=name,OU=unit,DC=domain,DC=local')
    end

    it 'handles users container' do
      result = CmdHelper.dn('name', 'users', 'domain')

      expect(result).to eq('CN=name,CN=users,DC=domain')
    end

    it 'handles builtin container' do
      result = CmdHelper.dn('name', 'Builtin', 'domain')

      expect(result).to eq('CN=name,CN=Builtin,DC=domain')
    end

    it 'handles computers container' do
      result = CmdHelper.dn('name', 'Computers', 'domain')

      expect(result).to eq('CN=name,CN=Computers,DC=domain')
    end

    it 'handles foreign security principals container' do
      result = CmdHelper.dn('name', 'ForeignSecurityPrincipals', 'domain')

      expect(result).to eq('CN=name,CN=ForeignSecurityPrincipals,DC=domain')
    end

    it 'handles managed service accounts container' do
      result = CmdHelper.dn('name', 'managed service accounts', 'domain')

      expect(result).to eq('CN=name,CN=managed service accounts,DC=domain')
    end

    it 'handles empty OUs' do
      result = CmdHelper.dn('name', nil, 'domain')

      expect(result).to eq('CN=name,DC=domain')
    end
  end

  describe '#ou_partial_dn' do
    it 'returns an empty string when given a nil value' do
      result = CmdHelper.ou_partial_dn(nil)
      expect(result).to eq('')
    end

    it 'returns an empty string when given an empty string' do
      result = CmdHelper.ou_partial_dn('')
      expect(result).to eq('')
    end

    it 'handles single OUs' do
      result = CmdHelper.ou_partial_dn('ou')
      expect(result).to eq('OU=ou')
    end

    it 'handles nested OUs' do
      result = CmdHelper.ou_partial_dn('ou1/ou2')
      expect(result).to eq('OU=ou2,OU=ou1')
    end
  end

  describe '#domain_partial_dn' do
    it 'returns an empty string when given a nil value' do
      result = CmdHelper.dc_partial_dn(nil)
      expect(result).to eq('')
    end

    it 'returns an empty string when given an empty string' do
      result = CmdHelper.dc_partial_dn('')
      expect(result).to eq('')
    end

    it 'handles simple domains' do
      result = CmdHelper.dc_partial_dn('domain')
      expect(result).to eq('DC=domain')
    end

    it 'handles nested domains' do
      result = CmdHelper.dc_partial_dn('domain.local')
      expect(result).to eq('DC=domain,DC=local')
    end
  end

  describe '#ou_leaf' do
    it 'returns an empty string when given a nil value' do
      result = CmdHelper.ou_leaf(nil)
      expect(result).to eq('')
    end

    it 'returns an empty string when given an empty string' do
      result = CmdHelper.ou_leaf('')
      expect(result).to eq('')
    end

    it 'handles single OUs' do
      result = CmdHelper.ou_leaf('ou')
      expect(result).to eq('ou')
    end

    it 'handles nested OUs' do
      result = CmdHelper.ou_leaf('ou1/ou2')
      expect(result).to eq('ou2')
    end
  end
end
