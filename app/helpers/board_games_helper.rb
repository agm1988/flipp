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

    fa_icon("bug 3x rotate-#{degree}")
  end
end
