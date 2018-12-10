module CommandFileProcessorService
  # TODO: rescue file parse errors and add messages to protocol or interface
  def self.call(file)
    parsed_commands = FileParserClient.call(file)

    protocol = {}
    parsed_commands.each do |cmd|
      protocol = ::Board::Game.call(ENV['SIZE_OF_BOARD_CALCULATED_FROM_ZERO'].to_i,
                                    x: protocol[:x],
                                    y: protocol[:y],
                                    face: protocol[:face]
      ).run(cmd)
    end

    protocol
  end
end
