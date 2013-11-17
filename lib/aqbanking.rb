require 'aqbanking/version'
require 'aqbanking/commander'
require 'aqbanking/user'
require 'aqbanking/account'
require 'aqbanking/transaction'

module AqBanking
  class << self

    def config=(path)
      @config = path
    end

    def config
      @config ||= '.'
    end


  end

end
