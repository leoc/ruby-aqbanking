require 'spec_helper'

describe AqBanking::Commander do

  describe '::with_pin' do
    let(:user) { double('User', bank: '123', user_id: '456') }
    let(:pin) { 'secure' }

    it 'creates a temporary pinfile with 400' do
      AqBanking::Commander.with_pin(user, pin) do
        File.read(pinfile).should == "PIN_123_456 = \"secure\"\n"
      end
    end

    it 'deletes the file afterwards' do
      path = nil
      AqBanking::Commander.with_pin(user, pin) do
        path = pinfile
      end
      expect(File).not_to exist(path)
    end

    it 'executes the given block inside a commander context' do
      context = nil
      AqBanking::Commander.with_pin(user, pin) do
        context = self
      end
      context.should(be_a AqBanking::Commander::Context)
    end
  end

end
