# frozen_string_literal: true

class Player
  attr_accessor :id
  attr_accessor :name
  attr_accessor :x
  attr_accessor :y
  attr_accessor :score

  def initialize
    self.id = ''
    self.name = ''
    self.x = 0
    self.y = 0
    self.score = 0
  end

  def initialize(id = 'n/a', name = '', x = 0, y = 0)
    self.id = id
    self.name = name
    self.x = x
    self.y = y
    self.score = 0
  end

  def to_h
    hash = {}
    instance_variables.each { |var| hash[var.to_s.delete('@')] = instance_variable_get(var) }
    hash
  end
end
