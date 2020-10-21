extends Area2D

signal pickup
signal hurt

enum {
	RIGHT
	LEFT
}

enum {
	IDLE,
	RUN,
	HURT
}

enum {
	COINS
	POWERUPS
	OBSTACLES
}

export (int) var speed

var screensize
var velocity
var state = IDLE
var facing = RIGHT
var animations = ['idle', 'run', 'hurt']
var groups = ['coins', 'powerups', 'obstacles']
var directions = {
	'ui_left' : Vector2(-1,  0),
	'ui_right': Vector2( 1,  0),
	'ui_up'   : Vector2( 0, -1),
	'ui_down' : Vector2( 0,  1)
}

func end():
	$AnimatedSprite.animation = animations[HURT]
	set_process(false)

func _on_Player_area_entered(area):
	for value in groups:
		if area.is_in_group(value):
			if area.has_method('pickup'):
				area.pickup()
				emit_signal("pickup", value)
			elif value == groups[OBSTACLES]:
				emit_signal("hurt")
				end()

func init(pos):
	set_process(true)
	position = pos
	$AnimatedSprite.animation = animations[IDLE]

func set_animation():
	$AnimatedSprite.animation = animations[state]
	$AnimatedSprite.flip_h = facing

func set_position_limits():
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)

func handle_input():
	velocity = Vector2()

	for key in directions.keys():
		if Input.is_action_pressed(key):
			velocity += directions[key]

func _process(delta):
	handle_input()

	if velocity.length() > 0:
		state = RUN
	else:
		state = IDLE

	if velocity.x < 0:
		facing = LEFT
	elif velocity.x > 0:
		facing = RIGHT

	if state == RUN:
		velocity = velocity.normalized() * speed
	position += velocity * delta

	set_position_limits()
	set_animation()

func _ready():
	pass
