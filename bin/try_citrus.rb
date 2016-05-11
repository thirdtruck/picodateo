require 'citrus'
require 'pry'
require 'pp'

Actor = Struct.new(:name) do
end

Scene = Struct.new(:name, :commands) do
end

Speech = Struct.new(:actor, :text) do
end

scenes = {}

Citrus.load 'bin/picodateo'
m = PicoDateo.parse File.read('game/scripts/citrus.dateo')
binding.pry
pp m.value
puts
