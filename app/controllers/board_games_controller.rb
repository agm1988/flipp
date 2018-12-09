class BoardGamesController < ApplicationController
  before_action :clear_board_session, only: [:index]

  def index
  end

  def process_command
    @protocol = ::Board::Game.new(x: session[:board_game_x],
                                  y: session[:board_game_y],
                                  face: session[:board_game_face]
    ).call(params[:game][:command])

    update_board_session(@protocol)
  end

  private

  def update_board_session(protocol)
    session[:board_game_x] = protocol[:x]
    session[:board_game_y] = protocol[:y]
    session[:board_game_face] = protocol[:face]
  end

  def clear_board_session
    session[:board_game_x] = nil
    session[:board_game_y] = nil
    session[:board_game_face] = nil
  end
end
