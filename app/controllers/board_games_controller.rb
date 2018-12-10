class BoardGamesController < ApplicationController
  before_action :clear_board_session, only: [:index, :process_command_file]

  def index
  end

  def process_command
    @protocol = ::Board::Game.call(ENV['SIZE_OF_BOARD_CALCULATED_FROM_ZERO'].to_i,
                                   x: session[:board_game_x],
                                   y: session[:board_game_y],
                                   face: session[:board_game_face]
    ).run(params[:game][:command])

    update_board_session(@protocol)
  end

  def process_command_file
    @protocol = CommandFileProcessorService.call(params['game']['command_file'])

    render 'process_command'
  rescue => e
    render 'file_upload_error', locals: { error_message: e.message }
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
