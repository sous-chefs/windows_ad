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
end
