require 'rails_helper'

RSpec.describe CommandFileProcessorService, type: :service do
  let(:csv_file) { fixture_file_upload(Rails.root.join('spec', 'support', 'files', 'command_file.csv'), 'text/csv') }
  let(:txt_file) { fixture_file_upload(Rails.root.join('spec', 'support', 'files', 'command_file.txt'), 'text/txt') }

  describe '#call' do
    specify 'parse csv file' do
      protocol = CommandFileProcessorService.call(csv_file)

      expect(protocol[:x]).to eq(3)
      expect(protocol[:y]).to eq(3)
      expect(protocol[:face]).to eq('NORTH')
      expect(protocol[:status]).to eq(:success)
      expect(protocol[:message]).to eq('ok')
    end

    specify 'parse txt file' do
      protocol = CommandFileProcessorService.call(txt_file)

      expect(protocol[:x]).to eq(3)
      expect(protocol[:y]).to eq(3)
      expect(protocol[:face]).to eq('NORTH')
      expect(protocol[:status]).to eq(:success)
      expect(protocol[:message]).to eq('ok')
    end
  end
end
