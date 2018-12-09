module Board
  class Game
    BOARD_SIZE = 5.freeze
    X_AXIS_LOCATIONS = %w[WEST EAST].freeze
    Y_AXIS_LOCATIONS = %w[NORTH SOUTH].freeze
    FACE_LOCATIONS = X_AXIS_LOCATIONS.zip(Y_AXIS_LOCATIONS).flatten.freeze
    POSITIVE_MOVE_FACE_LOCATIONS = %w[NORTH EAST].freeze
    STEP = 1.freeze
    PLACE_CMD = /\APLACE\s\d,\s\d,\s(?:west|north|east|south)\z/i

    attr_reader :x, :y, :face

    def initialize(x: nil, y: nil, face: nil)
      @x = x
      @y = y
      @face = face
    end

    def call(command)
      command.upcase!
      check_initial_location_set(command)
      process_command(command)

      Protocol.call(game: self, status: :success, message: 'ok', board_size: BOARD_SIZE)
    rescue => e
      Protocol.call(game: self, status: :error, message: e.message, board_size: BOARD_SIZE)
    end

    private

    def check_initial_location_set(cmd)
      puts cmd
      return if cmd.match?(PLACE_CMD)
      return if @x && @y && @face

      raise Exceptions::InitialLocationNotSetException
    end

    def process_command(cmd)
      puts "Process command"
      case cmd
      when PLACE_CMD
        process_place_command(cmd)
      when "MOVE"
        process_move
      when "LEFT", "RIGHT"
        process_turn(cmd)
      when "REPORT"
        { x: @x, y: y, face: @face }
      else
        raise Exceptions::UnknownCommandException
      end
    end

    def process_place_command(cmd)
      data = cmd.gsub("PLACE ", "").split(", ")
      @x = data[0].to_i
      @y = data[1].to_i
      @face = data[2]
    end

    def process_turn(cmd)
      turn_mod = cmd == 'LEFT' ? -1 : 1
      idx = FACE_LOCATIONS.index(@face) + STEP * turn_mod
      new_idx = idx == FACE_LOCATIONS.size ? 0 : idx
      @face = FACE_LOCATIONS[new_idx]
    end

    def process_move
      move_mod = POSITIVE_MOVE_FACE_LOCATIONS.include?(@face) ? 1 : -1
      axis = X_AXIS_LOCATIONS.include?(@face) ? :x : :y

      new_value = instance_variable_get("@#{axis}") + STEP * move_mod
      raise Exceptions::BoardExceededException if new_value < 0 || new_value >= BOARD_SIZE

      instance_variable_set("@#{axis}", new_value)
    end
  end
end
#
# board = Board::Game.new
# puts board.call("MOVE")
#
# puts board.call("PLACE 0, 0, EAST")
# puts board.call("MOVE")
# puts board.call("MOVE")
# puts board.call("LEFT")
# puts board.call("MOVE")
# puts board.call("MOVE")
# puts board.call("MOVE")
# puts board.call("MOVE")
# puts board.call("MOVE")
