# frozen_string_literal: true

class State
  attr_accessor :players
  attr_accessor :fruits
  attr_accessor :screen

  def initialize
    self.players = {}
    self.fruits = {}
    self.screen = Screen.new
  end

  def addPlayer(player)
    players[player.id] = player
  end

  def removePlayer(player)
    players.delete(player.id)
  end

  def addFruit(fruit)
    fruits[fruit.id] = fruit
  end

  def removeFruit(fruit)
    fruits.delete(fruit.id)
  end

  def to_h
    hash = {}
    instance_variables.each { |var| hash[var.to_s.delete('@')] = instance_variable_get(var) }
    hash
  end
end
