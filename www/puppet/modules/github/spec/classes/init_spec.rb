require 'spec_helper'
describe 'github' do

  context 'with defaults for all parameters' do
    it { should contain_class('github') }
  end
end
