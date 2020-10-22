extends Node

var levels = ["res://levels/Level1.tscn"]
var start_screen = "res://interface/StartScreen.tscn"
var end_screen = "res://interface/EndScreen.tscn"
var current_level
var score = 0

func game_over():
	get_tree().change_scene(end_screen)

func next_level():
	current_level += 1

	if current_level >= Global.levels.size():
		game_over()
	else:
		get_tree().change_scene(levels[current_level])

func new_game():
	current_level = -1
	score = 0
	next_level()

#func _process(delta):
#	pass

func _ready():
	pass
