module Board
  module Exceptions
    class BoardExceededException < BaseException
      def message
        'Board exceeding move'
      end
    end
  end
end
