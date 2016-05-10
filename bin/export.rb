class ActorEvent
  attr_accessor :actor, :text

  def initialize(actor, text)
    self.actor = actor
    self.text = text
  end

  def to_s
    # TODO: Add escape sequences
    if actor == :_narrator
      "type=\"narration\",text=\"#{text}\""
    else
      "type=\"speech\",speaker=\"#{actor}\",text=\"#{text}\""
    end
  end
end

class StageDirection
  attr_accessor :actor, :instructions

  def initialize(actor, instructions)
    self.actor = actor
    self.instructions = instructions
  end

  def to_s
    "type=\"stage_direction\",actor=\"#{actor}\",instructions=\"#{instructions}\""
  end
end

class Assignment
  attr_accessor :variable, :value

  def initialize(variable, value)
    self.variable = variable
    self.value = value
  end

  def to_s
    %Q(type="assignment",variable="#{variable}",value=#{value})
  end
end

class Increment
  attr_accessor :variable

  def initialize(variable)
    self.variable = variable
  end

  def to_s
    %Q(type="increment",variable="#{variable}")
  end
end

class Decrement
  attr_accessor :variable

  def initialize(variable)
    self.variable = variable
  end

  def to_s
    %Q(type="decrement",variable="#{variable}")
  end
end

class Option
  attr_accessor :text, :next_scene

  def initialize(text, next_scene)
    self.text = text
    self.next_scene = next_scene
  end

  def to_s
    "text=\"#{text}\",go_to=\"#{next_scene}\""
  end
end

class Choice
  attr_accessor :options

  def initialize
    self.options = []
  end

  def to_s
    option_strings = options.map {|o| "{#{o}}" }
    "type=\"choice\",options={#{option_strings.join(',')}}"
  end
end

class Scene
  attr_accessor :commands

  def initialize(commands)
    self.commands = commands
  end

  def to_s
    commands.map {|c| "{#{c}}"}.join(',')
  end
end

class Game
  attr_accessor :scenes

  def initialize
    self.scenes = {}
  end

  def to_s
    scene_strings = []
    scenes.each_pair do |name, commands|
      scene = Scene.new(commands)
      scene_strings << "#{name}={#{scene}}"
    end
    "scenes={#{scene_strings.join(',')}}"
  end
end

game = Game.new

script_text = File.read('game/scripts/main.dateo')

scene_name = nil
scene_commands = []

choice = nil

script_text.each_line do |line|
  line.strip!
  if line =~ /^scene:\s*(\w+)$/
    new_scene_name = $1.to_sym

    if scene_name
      if choice
        scene_commands.push(choice)
        choice = nil
      end
      game.scenes[scene_name] = scene_commands
    end

    scene_name = new_scene_name
    scene_commands = []
    choice = nil
  end

  if line =~ /^choice:$/
    choice = Choice.new
  end

  if line =~ /^option\((\w+)\):\s*(.*)$/
    next_scene = $1.to_sym
    text = $2

    option = Option.new(text, next_scene)
    choice.options.push(option)
  end

  if line =~ /^\[(\w*)\]\s*(.*)$/
    actor = $1 != "" ? $1.to_sym : :_narrator
    text = $2
    
    actor_event = ActorEvent.new(actor, text)
    scene_commands.push(actor_event)
  end

  if line =~ /^\[(\w*)\|(\w*)\]$/
    actor = $1 != "" ? $1.to_sym : :_narrator
    instructions = $2.to_sym

    stage_direction = StageDirection.new(actor, instructions)
    scene_commands.push(stage_direction)
  end

  if line =~ /^\[set:(\w+)=\d+\]$/
    variable = $1
    value = $2.to_i

    assignment = Assignment.new(variable, value)
    scene_commands.push(assignment)
  end

  if line =~ /^\[inc:(\w+)\]$/
    variable = $1

    assignment = Increment.new(variable)
    scene_commands.push(assignment)
  end

  if line =~ /^\[dec:(\w+)\]$/
    variable = $1

    assignment = Decrement.new(variable)
    scene_commands.push(assignment)
  end
end

if choice
  scene_commands.push(choice)
  choice = nil
end

game.scenes[scene_name] = scene_commands

print game
