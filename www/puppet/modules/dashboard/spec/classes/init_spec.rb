require 'spec_helper'
describe 'dashboard' do

  context 'with defaults for all parameters' do
    it { should contain_class('dashboard') }
  end
end
