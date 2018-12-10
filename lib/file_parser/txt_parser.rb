# frozen_string_literal: false

module FileParser
  class TxtParser < Base
    # PLACE 1,2,EAST
    # MOVE
    # MOVE
    # LEFT
    # MOVE
    # REPORT
    def parse_data
      get_txt(@file)
        .map { |cmd| cmd.gsub("\n", '').gsub("\t", '') }
        .map(&:strip)
        .keep_if { |cmd| cmd.present? }
    end

    private

    def get_txt(f)
      blob = File.open(f.path, 'r')

      data = []
      blob.each do |line|
        data << line
      end

      data
    ensure
      blob.close
    end
  end
end
