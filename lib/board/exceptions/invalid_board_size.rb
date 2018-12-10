module Board
  module Exceptions
    class InvalidBoardSize < BaseException
      def message
        'Invalid board size'
      end
    end
  end
end
