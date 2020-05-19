# frozen_string_literal: true

class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'game_channel'
  end

  def unsubscribed
    puts 'unsubscribed'
    # Any cleanup needed when channel is unsubscribed
  end
end
