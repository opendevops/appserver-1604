require 'spec_helper'
describe 'xdebug' do

  context 'with defaults for all parameters' do
    it { should contain_class('xdebug') }
  end
end
