require 'rails_helper'

RSpec.describe FileParser::CSVParser do
  let(:csv_file) { fixture_file_upload(Rails.root.join('spec', 'support', 'files', 'command_file.csv'), 'text/csv') }

  describe '#parse_data' do
    specify do
      expect(FileParser::CSVParser.new(csv_file).parse_data)
        .to eq(['PLACE 1,2,EAST', 'MOVE', 'MOVE', 'LEFT', 'MOVE', 'REPORT'])
    end
  end

  describe '#get_csv' do
    specify do
      expect(FileParser::CSVParser.new(csv_file).send(:get_csv, csv_file))
        .to eq([
                 ['PLACE 1,2,EAST', nil],
                 ['MOVE', nil],
                 ['MOVE', nil],
                 ['LEFT', nil],
                 ['MOVE', nil],
                 ['REPORT', nil],
                 []
               ])
    end
  end
end
