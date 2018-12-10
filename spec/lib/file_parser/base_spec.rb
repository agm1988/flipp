require 'rails_helper'

RSpec.describe FileParser::Base do
  describe '#call' do
    specify do
      expect(FileParser::Base.call(nil)).to eq([])
    end

    specify do
      expect { FileParser::Base.call('file_path') }.to raise_exception('Not implemented method #parse_data')
    end
  end
end
