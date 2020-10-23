extends Node

func _on_Player_shoot(scene, position, direction):
	var bullet = scene.instance()
	bullet.start(position, direction)
	add_child(bullet)

func _ready():
	pass
