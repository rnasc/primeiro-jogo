# frozen_string_literal: true

class HomeController < ApplicationController
  def main; end

  def message
    p1 = Player.new
    p1.id = 'id-p1'
    p1.name = 'Rogerio'
    p1.x = 3
    p1.y = 2

    game = Game.instance
    game.state.addPlayer(p1)
    ActionCable.server.broadcast 'game_channel', { message: 'Hello from the controller', game: game.to_h }
  end

  # def move_player(command); end
end
