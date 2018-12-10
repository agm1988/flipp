# frozen_string_literal: false

module FileParser
  class Base
    def self.call(file)
      parser = self.new(file)
      parser.file.nil? ? [] : parser.parse_data
    end

    attr_reader :file

    def initialize(file)
      @file = file
    end

    def parse_data
      fail NotImplementedError, 'Not implemented method #parse_data'
    end
  end
end
