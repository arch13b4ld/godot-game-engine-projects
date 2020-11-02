extends Node2D

signal score_changed

export (PackedScene) var Collectible

var pickups

var pickup_types = [
	'cherry',
	'gem'
]

var score setget set_score

func spawn_pickups():
	for cell in pickups.get_used_cells():
		var id = pickups.get_cellv(cell)
		var type = pickups.tile_set.tile_get_name(id)

		if type in pickup_types:
			var collectible = Collectible.instance()
			var spawn_position = pickups.map_to_world(cell)

			collectible.init(type, spawn_position + pickups.cell_size / 2)
			add_child(collectible)
			collectible.connect('pickup', self, '_on_Collectible_pickup')

func set_camera_limits():
	var map_size = $TileMapWorld.get_used_rect()
	var cell_size = $TileMapWorld.cell_size

	$Player/Camera.limit_left = (map_size.position.x + 1) * cell_size.x
	$Player/Camera.limit_right = (map_size.end.x - 1) * cell_size.x
	$Player/Camera.limit_top = 0
	$Player/Camera.limit_bottom = map_size.end.y * cell_size.y

func set_score(value):
	score = value
	emit_signal("score_changed", score)

func _on_Door_body_entered(_body):
	GameState.next_level()

func _on_Player_dead():
	GameState.restart()

func _on_Collectible_pickup():
	self.score += 1
	$AudioPickup.play()

func _ready():
	self.score = 0

	pickups = $TileMapPickups
	pickups.hide()
	spawn_pickups()

	$Player.start($Player/PlayerSpawn.position)
	set_camera_limits()
