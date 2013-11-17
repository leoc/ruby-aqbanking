require 'spec_helper'

describe AqBanking::Commander do

  describe '::with_pin' do
    let(:user) { double('User', bank: '123', user_id: '456') }
    let(:pin) { 'secure' }

    it 'creates a temporary pinfile with 400' do
      AqBanking::Commander.with_pin(user, pin) do |f|
        f.should_not be_nil
        expect(File).to exist(f.path)
        File.read(f.path).should == "PIN_123_456 = \"secure\"\n"
      end
    end

    it 'deletes the file afterwards' do
      path = nil
      AqBanking::Commander.with_pin(user, pin) do |f|
        path = f.path.strip
      end
      expect(File).not_to exist(path)
    end
  end

end
