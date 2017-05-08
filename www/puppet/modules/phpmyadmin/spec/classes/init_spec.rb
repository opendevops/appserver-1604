require 'spec_helper'
describe 'phpmyadmin' do

  context 'with defaults for all parameters' do
    it { should contain_class('phpmyadmin') }
  end
end
