extends Area2D

signal pickup
signal hurt

enum {
	LEFT,
	RIGHT,
	UP,
	DOWN
}

enum {
	IDLE,
	RUN,
	HURT
}

export (int) var speed

var screensize
var velocity
var state

var directions = {
	'ui_left' : Vector2(-1,  0),
	'ui_right': Vector2( 1,  0),
	'ui_up'   : Vector2( 0, -1),
	'ui_down' : Vector2( 0,  1)
}

var animations = ['idle', 'run', 'hurt']

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

func start(pos):
	set_process(true)
	position = pos
	$AnimatedSprite.animation = "idle"

func die():
	$AnimatedSprite.animation = "hurt"
	set_process(false)

func set_animation():
	$AnimatedSprite.animation = animations[state]
	$AnimatedSprite.flip_h = velocity.x < 0

func set_position_limits():
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)

func normalize_velocity():
	if state == RUN:
		velocity = velocity.normalized() * speed

func set_state():
	if velocity.length() > 0:
		state = RUN
	else:
		state = IDLE
		
func handle_input():
	velocity = Vector2()

	for key in directions.keys():
		if Input.is_action_pressed(key):
			velocity += directions[key]

func _process(delta):
	handle_input()
	set_state()
	normalize_velocity()
	position += velocity * delta
	set_position_limits()
	set_animation()

func _ready():
	pass
