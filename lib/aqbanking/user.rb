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
          context: "1"
        }.merge(options)

        complain_missing_parameters(options)

        user = nil
        command = AqBanking::aqhbci('adduser', options)
        stdin, stdout, stderr, wait_thr = Open3.popen3(command)

        if wait_thr.value.success?
          user = User.new(options)
        else
          raise Exception, "Unable to create user: \n#{stderr.read}"
        end

        if user && pin
          AqBanking::with_secure_pin(user, pin) do |f|
            sysid_command = AqBanking::aqhbci('getsysid',
                                              user: options[:user],
                                              pinfile: f.path.strip)
            stdin, stdout, stderr, wait_thr = Open3.popen3(sysid_command)
            unless wait_thr.value.success?
              raise Exception, "Unable to get sysid:\n#{stderr.read}"
            end
          end
        end

        user
      end

      def remove(options = {})
        raise "Missing options: user" unless options[:user]
        command = AqBanking::aqhbci('deluser', user: options[:user])
        _, _, stderr, status = Open3.popen3(command)
        unless status.value.success?
          raise Exception, "Unable to remove user:\n#{stderr.read}"
        end
      end

      def complain_missing_parameters(hash)
        missing = []
        missing << :bank unless hash[:bank]
        missing << :user unless hash[:user]
        missing << :server unless hash[:server]
        missing << :username unless hash[:username]
        unless missing.empty?
          raise Exception, "Missing options: #{missing.join(', ')}"
        end
      end

    end
  end
end
