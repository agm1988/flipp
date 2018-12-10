# frozen_string_literal: false
require 'csv'

module FileParser
  class CSVParser < Base
    # PLACE 1,2,EAST;
    # MOVE;
    # MOVE;
    # LEFT;
    # MOVE;
    # REPORT;
    def parse_data
      get_csv(@file).flatten.compact
    end

    private

    def get_csv(f)
      # CSV.read(file.path, encoding: detect_encoding(file.path), headers: true, col_sep: ';')
      CSV.read(f.path, encoding: detect_encoding(f.path), headers: false, col_sep: ';')
    end

    def detect_encoding(file_path)
      contents = File.read(file_path)
      detection = CharlockHolmes::EncodingDetector.detect(contents)
      detection[:encoding]
    end
  end
end
