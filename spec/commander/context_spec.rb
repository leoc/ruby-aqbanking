require 'spec_helper'

describe AqBanking::Commander::Context do
  describe '::new' do
    let(:context) { AqBanking::Commander::Context.new('/my/path') }

    it 'takes a pinfile argument' do
      context.pinfile.should == '/my/path'
    end
  end
end
