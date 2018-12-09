module Board
  module Protocol
    def self.call(game:, status:, message:)
      { x: game.x,
        y: game.y,
        face: game.face,
        status: status,
        message: message,
        board_size: game.board_size,
        last_command: game.last_command }
    end
  end
end
