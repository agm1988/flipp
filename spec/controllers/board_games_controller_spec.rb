require 'rails_helper'

RSpec.describe BoardGamesController, type: :controller do
  let(:place_cmd) { 'PLACE 0,0,NORTH' }
  let(:move_cmd) { 'MOVE' }
  let(:left_cmd) { 'LEFT' }
  let(:right_cmd) { 'RIGHT' }
  let(:report_cmd) { 'REPORT' }
  let(:invalid_cmd) { 'invalid cmd' }

  let(:csv_file) { fixture_file_upload(Rails.root.join('spec', 'support', 'files', 'command_file.csv'), 'text/csv') }
  let(:txt_file) { fixture_file_upload(Rails.root.join('spec', 'support', 'files', 'command_file.txt'), 'text/txt') }

  describe 'GET #index' do
    specify 'returns http success' do
      get :index

      expect(response).to have_http_status(:success)
    end
  end

  describe '#process_command' do
    specify 'returns protocol' do
      post :process_command, xhr: true, params: { game: { command: place_cmd } }

      protocol = assigns(:protocol)
      expect(protocol[:x]).to eq(0)
      expect(protocol[:y]).to eq(0)
      expect(protocol[:face]).to eq('NORTH')
      expect(protocol[:status]).to eq(:success)
    end

    specify 'first command not place protocol' do
      post :process_command, xhr: true, params: { game: { command: move_cmd } }

      protocol = assigns(:protocol)
      expect(protocol[:x]).to be_nil
      expect(protocol[:y]).to be_nil
      expect(protocol[:face]).to be_nil
      expect(protocol[:status]).to eq(:error)
      expect(protocol[:message]).to eq('Initial location not set')
    end

    specify 'correctly process sequel of comamnds' do
      # PLACE 1,2,EAST
      # MOVE
      # MOVE
      # LEFT
      # MOVE
      # REPORT
      # Output: 3,3,NORTH
      post :process_command, xhr: true, params: { game: { command: 'PLACE 1,2,EAST' } }
      post :process_command, xhr: true, params: { game: { command: move_cmd } }
      post :process_command, xhr: true, params: { game: { command: move_cmd } }
      post :process_command, xhr: true, params: { game: { command: left_cmd } }
      post :process_command, xhr: true, params: { game: { command: move_cmd } }
      post :process_command, xhr: true, params: { game: { command: report_cmd } }

      protocol = assigns(:protocol)
      expect(protocol[:x]).to eq(3)
      expect(protocol[:y]).to eq(3)
      expect(protocol[:face]).to eq('NORTH')
      expect(protocol[:status]).to eq(:success)
      expect(protocol[:message]).to eq('ok')
    end
  end

  describe '#process_command_file' do
    specify 'csv file' do
      post :process_command_file, xhr: true, params: { game: { command_file: csv_file } }

      protocol = assigns(:protocol)
      expect(protocol[:x]).to eq(3)
      expect(protocol[:y]).to eq(3)
      expect(protocol[:face]).to eq('NORTH')
      expect(protocol[:status]).to eq(:success)
      expect(protocol[:message]).to eq('ok')
    end

    specify 'txt file' do
      post :process_command_file, xhr: true, params: { game: { command_file: txt_file } }

      protocol = assigns(:protocol)
      expect(protocol[:x]).to eq(3)
      expect(protocol[:y]).to eq(3)
      expect(protocol[:face]).to eq('NORTH')
      expect(protocol[:status]).to eq(:success)
      expect(protocol[:message]).to eq('ok')
    end

    specify 'process invalid file' do
      post :process_command_file, xhr: true, params: { game: { command_file: 'invalid.xlsx' } }

      expect(response).to render_template('file_upload_error')
    end
  end
end
