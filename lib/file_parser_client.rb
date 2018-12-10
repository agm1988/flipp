# frozen_string_literal: true

module FileParserClient
  VERSION = '1.0.0'.freeze

  # TODO: catch all parse errors and re raise with FileParserException
  def self.call(file)
    parser_class =
      case File.extname(file.original_filename)
      when '.csv'
        ::FileParser::CSVParser
      when '.txt'
        ::FileParser::TxtParser
      else
        raise 'Unknown file format'
      end

    parser_class.call(file)
  end
end
