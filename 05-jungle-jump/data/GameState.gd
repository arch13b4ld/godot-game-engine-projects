extends Node

var current_level = 1
var num_levels = 2

var MainScene = "res://data/Main.tscn"
var TitleScreen = "res://data/ui/TitleScreen.tscn"

func next_level():
	current_level += 1
	
	if current_level <= num_levels:
		get_tree().reload_current_scene()
	else:
		restart()

func restart():
	get_tree().change_scene(TitleScreen)

func _ready():
	pass
