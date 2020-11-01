extends Area2D

signal pickup

var textures = {
	'cherry': "res://assets/sprites/cherry.png",
	'gem'	: "res://assets/sprites/gem.png"
}

func init(type, new_position):
	$Sprite.texture = load(textures[type])
	position = new_position

func _on_Collectible_body_entered(_body):
	emit_signal("pickup")
	queue_free()

func _ready():
	pass
