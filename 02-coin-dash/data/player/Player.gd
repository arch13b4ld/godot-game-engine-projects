extends Area2D

signal pickup
signal hurt

export (int) var speed

var screensize = Vector2()
var velocity = Vector2()
var directions = {
	'ui_left': 	Vector2(-1, 0),
	'ui_right': Vector2(1, 0),
	'ui_up': 	Vector2(0, -1),
	'ui_down': 	Vector2(0, 1)
}

func _ready():
	pass

func _process(delta):
	get_input()

	position += velocity * delta
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)

	if velocity.length() > 0:
		$AnimatedSprite.animation = "run"
		$AnimatedSprite.flip_h = velocity.x < 0
	else:
		$AnimatedSprite.animation = "idle"

func _on_Player_area_entered(area):
	if area.is_in_group("coins"):
		area.pickup()
		emit_signal("pickup", "coin")
	if area.is_in_group("powerups"):
		area.pickup()
		emit_signal("pickup", "powerup")
	if area.is_in_group("obstacles"):
		emit_signal("hurt")
		die()

func get_input():
	velocity = Vector2()

	for key in directions.keys():
		if Input.is_action_pressed(key):
			velocity += directions[key]

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

func start(pos):
	set_process(true)
	position = pos
	$AnimatedSprite.animation = "idle"

func die():
	$AnimatedSprite.animation = "hurt"
	set_process(false)
