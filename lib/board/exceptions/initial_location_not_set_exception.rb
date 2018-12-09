module Board
  module Exceptions
    class InitialLocationNotSetException < BaseException
      def message
        'Initial location not set'
      end
    end
  end
end
