# frozen_string_literal: true

class Screen
  attr_accessor :width
  attr_accessor :height

  def initialize
    self.width = 10
    self.height = 10
  end

  def to_h
    hash = {}
    instance_variables.each { |var| hash[var.to_s.delete('@')] = instance_variable_get(var) }
    hash
  end
end
