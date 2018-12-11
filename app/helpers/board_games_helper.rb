module BoardGamesHelper
  def entity_icon(face)
    degree = case face
             when 'WEST'
               270
             when 'EAST'
               90
             when 'SOUTH'
               180
             else
               360
             end

    fa_icon("bug #{icon_size}x rotate-#{degree}")
  end

  def icon_size
    board_size = ENV['SIZE_OF_BOARD_CALCULATED_FROM_ZERO'].to_i

    return 1 if board_size >= 9
    return 2 if board_size > 6

    3
  end
end
