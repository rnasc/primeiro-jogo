# frozen_string_literal: true

# There's only one Game instance which will control all state.
# This limitation is aimed at a Proof of Concept (PoC) only, as
# in the future there could be multiple games
class Game
  include Singleton

  attr_accessor :state
  attr_accessor :fruit_interval

  def initialize
    self.state = State.new
    @fruit_interval = 5

    Thread.new do
      loop do
        add_fruit
        sleep @fruit_interval.to_i
      end
    end
  end

  def add_fruit
    if get_players.empty?
      get_fruits.each do |_k, _v|
        get_fruits.delete(_k)
      end
      return
    end

    fruit = Fruit.new
    state.addFruit(fruit)
    puts "> Creating a new fruit: #{fruit}"
    ActionCable.server.broadcast 'game_channel', { type: 'add-fruit', game: to_h }
    # dump_fruits
  end

  def get_players
    state.players
  end

  def get_fruits
    state.fruits
  end

  def dump_fruits
    puts '-> List of fruits'
    get_fruits.each { |_k, v| puts "Fruit: #{v.to_h}" }
  end

  def add_player(player_id)
    player = Player.new(player_id,
                        "Player #{get_players.count + 1}",
                        rand(0..state.screen.width),
                        rand(0..state.screen.height))

    state.addPlayer(player)

    puts "> Subscribe: #{player.to_h}"
    dump_players
  end

  def dump_players
    puts '-> List of online Players'
    get_players.each { |_k, v| puts "Player: #{v.to_h}" }
  end

  def remove_player(_player_id)
    player = get_players[_player_id]
    state.removePlayer(player)

    puts "> Unsubscribe: #{player.to_h}"
    # dump_players
  end

  def remove_fruit(fruit)
    # fruit = get_fruits[fruit] if fruit.is_a(String)
    state.removeFruit(fruit)
    puts "> Fruit removed: #{fruit.id}"
  end

  def to_h
    hash = {}
    instance_variables.each { |var| hash[var.to_s.delete('@')] = instance_variable_get(var) }
    hash
  end

  def move_player(command)
    method = command['content']['keyPressed']
    player_id = command['current_player_id']
    player = get_players[player_id]

    # equivalent to titleize, downcase, and replace spaces by underscore
    # ex:
    # method = "ArrowUp".tableize.singularize
    #  => "arrow_up"
    if method.present?
      method = method.tableize.singularize
      if respond_to? method
        ActionCable.server.broadcast 'game_channel', { type: 'move-player', game: to_h }
        public_send(method, player)
        check_for_fruit_collision(player)
      end
    end
  end

  def check_for_fruit_collision(_player)
    get_fruits.each do |_k, fruit|
      next unless _player.x == fruit.x && _player.y == fruit.y

      puts "> Deleting fruit #{fruit.id} player: #{_player.id}"
      remove_fruit(fruit)
      _player.score = _player.score + 1
    end
  end

  def arrow_up(player)
    puts '> Arrow Up '
    player.y = mod(state.screen.height, player.y - 1)
  end

  def arrow_right(player)
    puts '> Arrow Right'
    player.x = mod(state.screen.width, player.x + 1)
  end

  def arrow_down(player)
    puts '> Arrow Down'
    player.y = mod(state.screen.height, player.y + 1)
  end

  def arrow_left(player)
    puts '> Arrow Left'
    player.x = mod(state.screen.width, player.x - 1)
  end

  private

  def mod(x, y)
    ((y % x) + x) % x
  end
end
