module Board
  module Protocol
    def self.call(game:, status:, message:, board_size:)
      { x: game.x,
        y: game.y,
        face: game.face,
        status: status,
        message: message,
        board_size: board_size }
    end
  end
end
