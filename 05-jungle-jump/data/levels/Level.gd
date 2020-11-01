extends Node2D

signal score_changed

var pickups
var score setget set_score

func set_score(value):
	score = value
	emit_signal("score_changed", score)

func set_camera_limits():
	var map_size = $TileMapWorld.get_used_rect()
	var cell_size = $TileMapWorld.cell_size
	$Player/Camera.limit_left = (map_size.position.x - 5) * cell_size.x
	$Player/Camera.limit_right = (map_size.end.x + 5) * cell_size.x

func _ready():
	self.score = 0

	pickups = $TileMapPickups
	pickups.hide()

	$Player.start($Player/PlayerSpawn.position)
	set_camera_limits()
