require 'open3'

module AqBanking
  class User
    attr_accessor :name, :bank, :user_id, :server, :hbciversion

    def initialize(options = {})
      User.complain_missing_parameters(options)
    end

    class << self

      def add(options = {})
        pin = options.delete(:pin)
        options = {
          tokentype: 'pintan',
          hbciversion: 300,
          context: '1'
        }.merge(options)

        complain_missing_parameters(options)

        Commander.aqhbci('adduser', options)

        user = User.new(options)

        if user && pin
          Commander.with_pin(user, pin) do |f|
            aqhbci('getsysid', user: options[:user])
          end
        end

        user
      end

      def remove(options = {})
        fail 'Missing options: user' unless options[:user]
        Commander.aqhbci('deluser', user: options[:user])
      end

      def complain_missing_parameters(hash)
        missing = []
        missing << :bank unless hash[:bank]
        missing << :user unless hash[:user]
        missing << :server unless hash[:server]
        missing << :username unless hash[:username]
        fail "Missing options: #{missing.join(', ')}" unless missing.empty?
      end
    end
  end
end
