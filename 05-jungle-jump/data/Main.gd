extends Node

func _ready():
	var level_num = str(GameState.current_level).pad_zeros(2)
	var path = "res://data/levels/Level%s.tscn" % level_num
	var level = load(path).instance()

	add_child(level)
