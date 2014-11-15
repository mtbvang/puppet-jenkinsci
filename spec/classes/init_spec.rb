require 'spec_helper'
describe 'jenkinsci' do

  context 'with defaults for all parameters' do
    it { should contain_class('jenkinsci') }
  end
end
