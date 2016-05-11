require 'citrus'
require 'pry'
require 'pp'

Actor = Struct.new(:name) do
end

Scene = Struct.new(:name, :commands) do
  def to_s
    commands.map {|c| "{#{c}}"}.join(',')
  end
end

Speech = Struct.new(:actor, :text) do
  def to_s
    # TODO: Add explicit escape sequences, if necessary
    escaped_text = text.inspect
    if actor == :_narrator
      "type=\"narration\",text=#{escaped_text}"
    else
      "type=\"speech\",speaker=\"#{actor}\",text=#{escaped_text}"
    end
  end
end

Game = Struct.new(:scenes) do
  def to_s
    scene_strings = []
    scenes.each_pair do |name, scene|
      scene_strings << "#{name}={#{scene}}"
    end
    "scenes={#{scene_strings.join(',')}}"
  end
end

IfCond = Struct.new(:condition, :commands) do
  def to_s
    %Q{type="if" condition="#{condition}" commands={#{commands.map {|c| "{#{c}}"}.join(',')}}}
  end
end

Citrus.load 'bin/picodateo'
m = PicoDateo.parse File.read('game/scripts/citrus.dateo')
game = m.value
#binding.pry
puts game
