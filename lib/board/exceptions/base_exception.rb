module Board
  module Exceptions
    class BaseException < StandardError
      def message
        'Board game error'
      end
    end
  end
end
