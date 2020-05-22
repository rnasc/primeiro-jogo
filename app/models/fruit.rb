# frozen_string_literal: true

require 'securerandom'

class Fruit
  attr_accessor :id
  attr_accessor :x
  attr_accessor :y

  def initialize
    game = Game.instance

    self.id = SecureRandom.uuid
    self.x = rand(0..game.state.screen.width)
    self.y = rand(0..game.state.screen.height)
  end

  def to_h
    hash = {}
    instance_variables.each { |var| hash[var.to_s.delete('@')] = instance_variable_get(var) }
    hash
  end
end
