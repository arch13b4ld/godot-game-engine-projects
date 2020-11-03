extends Node

func _ready():
	var level_num = str(GameState.current_level)
	var path = "res://data/levels/Level0%s.tscn" % level_num
	var level = load(path).instance()

	add_child(level)
