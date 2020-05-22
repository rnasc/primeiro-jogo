# frozen_string_literal: true

require 'securerandom'

class GameChannel < ApplicationCable::Channel
  attr_accessor :channel_id

  def subscribed
    stream_from 'game_channel'

    @channel_id = SecureRandom.uuid
    @connection.session[:channel_id] = @channel_id

    game = Game.instance
    game.add_player(@channel_id)
  end

  def unsubscribed
    game = Game.instance
    game.remove_player(@channel_id)
  end

  def setup
    state = { id: 1 }
    transmit state
  end

  def move_player(data)
    # safely receive a Hash
    hash = (data.is_a?(String) ? to_hash(data) : (data.is_a?(Hash) ? data : {}))
    hash['current_player_id'] = @channel_id

    game = Game.instance
    game.move_player(hash)
  end

  private

  def to_hash(str)
    # Transform object string symbols to quoted strings
    str.gsub!(/([{,]\s*):([^>\s]+)\s*=>/, '\1"\2"=>')

    # Transform object string numbers to quoted strings
    str.gsub!(/([{,]\s*)([0-9]+\.?[0-9]*)\s*=>/, '\1"\2"=>')

    # Transform object value symbols to quotes strings
    str.gsub!(/([{,]\s*)(".+?"|[0-9]+\.?[0-9]*)\s*=>\s*:([^,}\s]+\s*)/, '\1\2=>"\3"')

    # Transform array value symbols to quotes strings
    str.gsub!(/([\[,]\s*):([^,\]\s]+)/, '\1"\2"')

    # Transform object string object value delimiter to colon delimiter
    str.gsub!(/([{,]\s*)(".+?"|[0-9]+\.?[0-9]*)\s*=>/, '\1\2:')

    puts str
    JSON.parse(str)
  end
end
