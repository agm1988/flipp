require 'rails_helper'

RSpec.describe FileParserClient do
  let(:file) { double }

  describe '#call' do
    specify 'CSVParser' do
      allow(file).to receive(:original_filename) { 'command_file.csv' }
      expect(FileParser::CSVParser).to receive(:call).with(file)

      FileParserClient.call(file)
    end

    specify 'TxtParser' do
      allow(file).to receive(:original_filename) { 'command_file.txt' }
      expect(FileParser::TxtParser).to receive(:call).with(file)

      FileParserClient.call(file)
    end

    specify 'raises error' do
      allow(file).to receive(:original_filename) { 'command_file.some' }

      expect { FileParserClient.call(file) }.to raise_exception('Unknown file format')
    end
  end
end
