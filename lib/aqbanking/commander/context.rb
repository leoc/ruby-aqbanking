module AqBanking
  class Commander
    class Context
      attr_accessor :pinfile

      def initialize(pinfile, &block)
        @pinfile = pinfile
        define_singleton_method(:execute, block) if block_given?
      end
    end
  end
end
