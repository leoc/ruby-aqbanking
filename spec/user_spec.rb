require 'spec_helper'

describe AqBanking::User do
  describe '::add' do
    it 'needs bank option' do
      expect { AqBanking::User.add(username: "A", user: '123456789', server: 'http://www.google.com') }.to raise_error
    end

    it 'needs username option' do
      expect { AqBanking::User.add(bank: '12030000', user: '123456789', server: 'http://www.google.com') }.to raise_error
    end

    it 'needs user option' do
      expect { AqBanking::User.add(username: 'A', bank: '12030000', server: 'http://www.google.com') }.to raise_error
    end

    it 'needs server option' do
      expect { AqBanking::User.add(username: 'A', bank: '12030000', user: '123456789') }.to raise_error
    end

    context 'on success' do
      after(:each) do
        AqBanking::User.remove(user: '123456789')
      end

      it 'returns the new user' do
        user = AqBanking::User.add(username: "A", bank: '12030000', user: '123456789', server: 'http://www.google.com')
        user.should be_a AqBanking::User
      end
    end
  end

  describe '::remove' do
    it 'fails if unknown' do
      expect { AqBanking::User.remove(user: '123456789') }.to raise_error
    end

    it 'succeeds if known' do
      AqBanking::User.add(username: 'A', bank: '12030000',
                          user: '123456789', server: 'http://www.google.com')
      AqBanking::User.remove(user: '123456789').should == true
    end
  end
end
