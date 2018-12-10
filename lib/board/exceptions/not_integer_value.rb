module Board
  module Exceptions
    class NotIntegerValue < BaseException
      def message
        'Not integer value'
      end
    end
  end
end
