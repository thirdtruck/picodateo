require 'citrus'
require 'pry'
require 'pp'

Actor = Struct.new(:name) do
end

Scene = Struct.new(:name, :commands, :id) do
  def to_s
    commands.map {|c| "{#{c}}"}.join(',')
  end
end

SceneJump = Struct.new(:scene_name) do
  def to_s
    %Q(type="jump",go_to="#{scene_name}")
  end
end

VariableDeclaration = Struct.new(:id, :name, :starting_value) do
end

VariablesTable = Struct.new(:variable_declarations) do
  def to_s
    declarations = []
    variable_declarations.each do |vd|
      declarations[vd.id] = vd.name
    end

    variable_declaration_strings = (1..15).map do |i|
      if declarations[i] 
        %Q("#{declarations[i]}")
      else
        'nil'
      end
    end

    %Q(variable_declarations={#{variable_declaration_strings.join(',')}})
  end
end

class SavePoint
  def to_s
    %Q(type="save_point")
  end
end

StageDirection = Struct.new(:actor, :instructions) do
  def to_s
    %Q(type="stage_direction",actor="#{actor}",instructions="#{instructions}")
  end
end

Choice = Struct.new(:options) do
  def to_s
    option_text = options.map { |o| o.to_s }.join(',')
    %Q(type="choice",options={#{option_text}})
  end
end

Assignment = Struct.new(:variable, :value) do
  def to_s
    %Q(type="assignment",variable="#{variable}",value=#{value})
  end
end

Increment = Struct.new(:variable, :value) do
  def to_s
    %Q(type="increment",variable="#{variable}")
  end
end

Decrement = Struct.new(:variable, :value) do
  def to_s
    %Q(type="decrement",variable="#{variable}")
  end
end

Option = Struct.new(:text, :go_to) do
  def to_s
    %Q({text="#{text}",go_to="#{go_to}"})
  end
end

Speech = Struct.new(:speaker, :text) do
  def to_s
    # TODO: Add explicit escape sequences, if necessary
    escaped_text = text.inspect
    if speaker == :_narrator
      %Q(type="narration",text=#{escaped_text})
    else
      %Q(type="speech",speaker="#{speaker}",text=#{escaped_text})
    end
  end
end

def testing(name)
  require 'pry'; binding.pry
  puts name, name, name
  puts 'help!'
end

Game = Struct.new(:scenes, :variables_table) do
  def to_s
    scene_index = 1
    scenes.each do |scene_pair|
      scene = scene_pair[1]
      scene.id = scene_index
      scene_index += 1
    end

    scene_strings = []
    scene_id_strings = []
    scenes.each_pair do |name, scene|
      scene_strings << "#{name}={#{scene}}"
      scene_id_strings << "#{name}=#{scene.id}"
    end

    scenes_by_id = []
    scenes.each do |scene_pair|
      scene = scene_pair[1]
      scenes_by_id[scene.id] = scene
    end

    scene_name_strings = (1..64).map do |i|
      scene = scenes_by_id[i]
      if scene
        %Q("#{scene.name}")
      else
        'nil'
      end
    end

    variable_declarations_string = variables_table.to_s
    scene_ids_string = %Q(scene_ids={#{scene_id_strings.join(',')}})
    scene_names_string = %Q(scene_names={#{scene_name_strings.join(',')}})
    scenes_string = %Q(scenes={#{scene_strings.join(',')}})

    variable_declarations_string << "\n" << scene_ids_string << "\n" << scene_names_string << "\n" << scenes_string
  end
end

IfCond = Struct.new(:variable, :operand, :value, :commands) do
  def to_s
    command_strings = commands.map {|c| "{#{c}}"}.join(',')
    %Q(type="if",variable="#{variable}",operand="#{operand}",value=#{value},commands={#{command_strings}})
  end
end

Citrus.load 'bin/picodateo'
m = PicoDateo.parse File.read('game/scripts/citrus.dateo')
game = m.value
#binding.pry
puts game
