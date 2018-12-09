module Board
  module Exceptions
    class UnknownCommandException < BaseException
      def message
        'Unknown command'
      end
    end
  end
end
