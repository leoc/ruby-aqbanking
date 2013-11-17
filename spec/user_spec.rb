require 'spec_helper'

describe AqBanking::User do
  describe '::new' do
    let(:user) do
      AqBanking::User.new(username: 'username',
                          bank: 'bank',
                          user: 'user',
                          server: 'http://myserver.com',
                          hbciversion: 300,
                          context: '1')
    end

    it 'fails without username option' do
      expect {
        AqBanking::User.new(bank: 'bank', user: 'user')
      }.to raise_error
    end

    it 'fails without bank option' do
      expect {
        AqBanking::User.new(username: 'username', user: 'user')
      }.to raise_error
    end

    it 'fails without user option' do
      expect {
        AqBanking::User.new(username: 'username', bank: 'bank')
      }.to raise_error
    end

    it 'takes username option' do
      user.username.should == 'username'
    end

    it 'takes bank option' do
      user.bank.should == 'bank'
    end

    it 'takes user option' do
      user.user.should == 'user'
    end

    it 'takes server option' do
      user.server.should == 'http://myserver.com'
    end

    it 'takes hbciversion option' do
      user.hbciversion.should == 300
    end

    it 'takes context option' do
      user.context.should == '1'
    end
  end

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
