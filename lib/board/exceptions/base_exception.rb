module Board
  module Exceptions
    class BaseException < StandardError
      def message
        'Board game exception'
      end
    end
  end
end
