require 'rails_helper'

RSpec.describe Board::Game do
  subject { ::Board::Game.call(5) }
  let(:game_with_initial_location) { ::Board::Game.call(5, x: 0, y: 0, face: 'NORTH') }
  let(:north_face) { ::Board::Game.call(5, x: 0, y: 0, face: 'NORTH') }
  let(:east_face) { ::Board::Game.call(5, x: 0, y: 0, face: 'EAST') }
  let(:west_face) { ::Board::Game.call(5, x: 4, y: 4, face: 'WEST') }
  let(:south_face) { ::Board::Game.call(5, x: 4, y: 4, face: 'SOUTH') }
  let (:place_cmd) { 'PLACE 0,0,NORTH' }

  describe '#call' do
    context 'valid parameters' do
      specify 'return an instance' do
        board = Board::Game.call(2)

        expect(board).to be_an_instance_of(Board::Game)
      end
    end

    context 'invalid parameters' do
      specify 'raise error ::Board::Exceptions::InvalidBoardSize' do
        expect{ Board::Game.call(1) }.to raise_exception(::Board::Exceptions::InvalidBoardSize.new.message)
      end

      specify 'raise error ::Board::Exceptions::NotIntegerValue' do
        expect{ Board::Game.call('1') }.to raise_exception(::Board::Exceptions::NotIntegerValue.new.message)
      end
    end
  end

  describe '#run' do
    context 'initial location not set' do
      specify 'raises exception' do
        %w[MOVE LEFT RIGTH REPORT].each do |cmd|
          protocol = subject.run(cmd)

          expect(protocol[:status]).to eq(:error)
          expect(protocol[:message]).to eq('Initial location not set')
        end
      end
    end
  end

  describe '#check_initial_location' do
    context 'game without initial location' do
      specify 'raises an exception' do
        %w[MOVE LEFT RIGTH REPORT].each do |cmd|
          expect { subject.send(:check_initial_location_set, cmd) }
            .to raise_exception(Board::Exceptions::InitialLocationNotSetException.new.message)
        end
      end

      specify 'not raising an exception' do
        expect { subject.send(:check_initial_location_set, place_cmd) }
          .not_to raise_exception
      end
    end

    context 'game with initial location' do
      specify 'not raises exception' do
        %w[MOVE LEFT RIGTH REPORT].each do |cmd|
          expect { game_with_initial_location.send(:check_initial_location_set, cmd) }
            .not_to raise_exception
        end
      end
    end
  end

  describe '#process_command' do
    specify 'triggers process_palce_command' do
      expect(subject).to receive(:process_place_command).with(place_cmd)

      subject.run(place_cmd)
    end

    specify 'triggers process_move' do
      expect(game_with_initial_location).to receive(:process_move)

      game_with_initial_location.run('move')
    end

    specify 'triggers process_turn' do
      %w[left right].each do |cmd|
        expect(game_with_initial_location).to receive(:process_turn).with(cmd)

        game_with_initial_location.run(cmd)
      end
    end

    specify 'triggers process_report' do
      expect(game_with_initial_location).to receive(:process_report)

      game_with_initial_location.run('report')
    end

    specify 'triggers process_unknown_command' do
      expect(game_with_initial_location).to receive(:process_unknown_command)

      game_with_initial_location.run('unknown comand')
    end
  end

  describe '#process_place_command' do
    context 'invalid place command' do
      specify 'raises exception Board::Exceptions::BoardExceededException if X is small' do
        expect { subject.send(:process_place_command, 'PLACE -1,0,EAST') }
          .to raise_exception(Board::Exceptions::BoardExceededException)
      end

      specify 'raises exception Board::Exceptions::BoardExceededException if Y is small' do
        expect { subject.send(:process_place_command, 'PLACE 0,-1,EAST') }
          .to raise_exception(Board::Exceptions::BoardExceededException)
      end

      specify 'raises exception Board::Exceptions::BoardExceededException if x is too big' do
        expect { subject.send(:process_place_command, 'PLACE 6,0,EAST') }
          .to raise_exception(Board::Exceptions::BoardExceededException.new.message)
      end

      specify 'raises exception Board::Exceptions::BoardExceededException if Y is too big' do
        expect { subject.send(:process_place_command, 'PLACE 0,6,EAST') }
          .to raise_exception(Board::Exceptions::BoardExceededException)
      end
    end

    context 'valid place comand parameters' do
      specify do
        expect { subject.send(:process_place_command, 'PLACE 0,0,EAST') }
          .not_to raise_exception
      end
    end
  end

  describe '#process_turn' do
    specify 'LEFT command' do
      expect(game_with_initial_location.face).to eq('NORTH')

      game_with_initial_location.send(:process_turn, 'LEFT')

      expect(game_with_initial_location.face).to eq('WEST')
    end

    specify 'RIGHT command' do
      expect(game_with_initial_location.face).to eq('NORTH')

      game_with_initial_location.send(:process_turn, 'RIGHT')

      expect(game_with_initial_location.face).to eq('EAST')
    end
  end

  describe '#process_move' do
    specify do
      expect(game_with_initial_location.face).to eq('NORTH')
      expect(game_with_initial_location.x).to eq(0)
      expect(game_with_initial_location.y).to eq(0)

      game_with_initial_location.send(:process_move)

      expect(game_with_initial_location.face).to eq('NORTH')
      expect(game_with_initial_location.x).to eq(0)
      expect(game_with_initial_location.y).to eq(1)
    end

    specify do
      expect(west_face.face).to eq('WEST')
      expect(west_face.x).to eq(4)
      expect(west_face.y).to eq(4)

     west_face.send(:process_move)

      expect(west_face.face).to eq('WEST')
      expect(west_face.x).to eq(3)
      expect(west_face.y).to eq(4)
    end
  end

  describe '#process_report' do
    specify do
      expect { west_face.send(:process_report) }
        .to change(west_face, :last_command).to(:report)
    end
  end

  describe '#process_unknown_command' do
    specify 'changes last_command' do
      expect { west_face.send(:process_unknown_command) }
        .to raise_exception(Board::Exceptions::UnknownCommandException.new.message)
    end
  end

  describe '#find_axis' do
    specify do
      expect(north_face.send(:find_axis)).to eq(:y)
      expect(south_face.send(:find_axis)).to eq(:y)

      expect(west_face.send(:find_axis)).to eq(:x)
      expect(east_face.send(:find_axis)).to eq(:x)
    end
  end

  describe '#move_mode' do
    specify do
      expect(north_face.send(:move_mode)).to eq(1)
      expect(south_face.send(:move_mode)).to eq(-1)

      expect(west_face.send(:move_mode)).to eq(-1)
      expect(east_face.send(:move_mode)).to eq(1)
    end
  end

  # just to bump simplecov coverage and don't bother with separate file
  specify do
    expect(Board::Exceptions::BaseException.new.message).to eq('Board game exception')
  end
end
