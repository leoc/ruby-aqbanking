module AqBanking
  class Commander
    class Context
      attr_accessor :pinfile

      def initialize(pinfile, &block)
        @pinfile = pinfile
        define_singleton_method(:execute, block) if block_given?
      end

      def aqhbci(command, options = {})
        options = {
          pinfile: pinfile
        }.merge(options)
        Commander.aqhbci(command, options)
      end

      def aqcli(command, options = {})
        options = {
          pinfile: pinfile
        }.merge(options)
        Commander.aqcli(command, options)
      end
    end
  end
end
