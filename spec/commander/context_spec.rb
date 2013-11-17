require 'spec_helper'

describe AqBanking::Commander::Context do
  let(:context) { AqBanking::Commander::Context.new('/my/path') }

  describe '::new' do
    it 'takes a pinfile argument' do
      context.pinfile.should == '/my/path'
    end
  end

  describe '#aqhbci' do
    it 'executes Commander::aqhbci with :pinfile option' do
      expect(AqBanking::Commander).to receive(:aqhbci).with('command', hash_including(pinfile: '/my/path'))
      context.aqhbci('command')
    end
  end

  describe '#aqcli' do
    it 'executes Commander::aqcli with :pinfile option' do
      expect(AqBanking::Commander).to receive(:aqcli).with('command', hash_including(pinfile: '/my/path'))
      context.aqcli('command')
    end
  end
end
