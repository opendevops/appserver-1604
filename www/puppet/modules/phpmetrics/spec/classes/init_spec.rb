require 'spec_helper'
describe 'phpmetrics' do

  context 'with defaults for all parameters' do
    it { should contain_class('phpmetrics') }
  end
end
