module Board
  class Game
    MIN_BOARD_SIZE = 2.freeze
    X_AXIS_LOCATIONS = %w[WEST EAST].freeze
    Y_AXIS_LOCATIONS = %w[NORTH SOUTH].freeze
    FACE_LOCATIONS = X_AXIS_LOCATIONS.zip(Y_AXIS_LOCATIONS).flatten.freeze
    POSITIVE_MOVE_FACE_LOCATIONS = %w[NORTH EAST].freeze
    STEP = 1.freeze
    PLACE_CMD = /\APLACE\s\d,\d,(?:west|north|east|south)\z/i

    attr_reader :x, :y, :face, :board_size, :last_command

    def initialize(board_size, x:, y:, face:)
      @x = x
      @y = y
      @face = face
      @board_size = board_size
    end

    def self.call(board_size, x: nil, y: nil, face: nil)
      raise Exceptions::NotIntegerValue unless board_size.is_a?(Integer)
      raise Exceptions::InvalidBoardSize if board_size < MIN_BOARD_SIZE

      new(board_size, x: x, y: y, face: face)
    end

    # TODO: check command is known first to show proper error
    def run(command)
      command.upcase!
      check_initial_location_set(command)
      process_command(command)

      Protocol.call(game: self, status: :success, message: 'ok')
    rescue Exceptions::BoardExceededException, Exceptions::InitialLocationNotSetException, Exceptions:: UnknownCommandException => e
      Protocol.call(game: self, status: :error, message: e.message)
    end

    private_class_method :new

    private

    def check_initial_location_set(cmd)
      return if cmd.match?(PLACE_CMD)
      return if @x && @y && @face

      raise Exceptions::InitialLocationNotSetException
    end

    def process_command(cmd)
      case cmd
      when PLACE_CMD
        process_place_command(cmd)
      when 'MOVE'
        process_move
      when 'LEFT', 'RIGHT'
        process_turn(cmd)
      when 'REPORT'
        process_report
      else
        process_unknown_command
      end
    end

    def process_place_command(cmd)
      data = cmd.gsub('PLACE ', '').split(',')
      x_value = data[0].to_i
      y_value = data[1].to_i

      raise Exceptions::BoardExceededException if x_value < 0 || x_value > @board_size
      raise Exceptions::BoardExceededException if y_value < 0 || y_value > @board_size

      @x = x_value
      @y = y_value
      @face = data[2]
      @last_command = :place
    end

    def process_turn(cmd)
      turn_mod = cmd == 'LEFT' ? -1 : 1
      idx = FACE_LOCATIONS.index(@face) + STEP * turn_mod
      new_idx = idx == FACE_LOCATIONS.size ? 0 : idx

      @face = FACE_LOCATIONS[new_idx]
      @last_command = cmd.downcase.to_sym
    end

    def process_move
      axis = find_axis
      new_value = instance_variable_get("@#{axis}") + STEP * move_mode

      raise Exceptions::BoardExceededException if new_value < 0 || new_value > @board_size

      instance_variable_set("@#{axis}", new_value)
      @last_command = :move
    end

    def process_report
      @last_command = :report
    end

    def process_unknown_command
      @last_command = :unknown

      raise Exceptions::UnknownCommandException
    end

    def find_axis
      X_AXIS_LOCATIONS.include?(@face) ? :x : :y
    end

    def move_mode
      POSITIVE_MOVE_FACE_LOCATIONS.include?(@face) ? 1 : -1
    end
  end
end
