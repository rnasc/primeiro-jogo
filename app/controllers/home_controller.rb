# frozen_string_literal: true

class HomeController < ApplicationController
  def main; end

  def message
    ActionCable.server.broadcast 'game_channel', content: { message: 'Hello from controller' }
  end
end
