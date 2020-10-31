extends Node2D

var pickups

func _ready():
	pickups = $TileMapPickups
	pickups.hide()

	$Player.start($Player/PlayerSpawn.position)
