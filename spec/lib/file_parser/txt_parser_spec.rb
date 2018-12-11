require 'rails_helper'

RSpec.describe FileParser::TxtParser do
  let(:txt_file) { fixture_file_upload(Rails.root.join('spec', 'support', 'files', 'command_file.txt'), 'text/txt') }

  describe '#parse_data' do
    specify do
      expect(FileParser::TxtParser.new(txt_file).parse_data)
        .to eq(['PLACE 1,2,EAST', 'MOVE', 'MOVE', 'LEFT', 'MOVE', 'REPORT'])
    end
  end

  describe '#get_txt' do
    specify do
      expect(FileParser::TxtParser.new(txt_file).send(:get_txt, txt_file))
        .to eq(["PLACE 1,2,EAST\n", "MOVE\n", "MOVE\n", "LEFT\n", "MOVE\n", "REPORT\n", "\n"])
    end
  end
end
