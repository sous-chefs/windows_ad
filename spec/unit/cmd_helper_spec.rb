require 'spec_helper'
require_relative '../../libraries/cmd_helper'

describe 'cmd_helper' do
  describe '#cmd_options' do
    it 'builds an empty string when there are no options' do
      result = CmdHelper.cmd_options({})
      
      expect(result).to be_empty
    end

    it 'adds a minus to the options and wrapps the vlaues in double quotes' do
      result = CmdHelper.cmd_options({'opt1' => 'val1', 'opt2' => 'val2'})
      
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

    it 'handles users OU' do
      result = CmdHelper.dn('name', 'users', 'domain')

      expect(result).to eq('CN=name,CN=users,DC=domain')
    end

    it 'handles empty OUs' do
      result = CmdHelper.dn('name', nil, 'domain')

      expect(result).to eq('CN=name,DC=domain')
    end
  end
end
