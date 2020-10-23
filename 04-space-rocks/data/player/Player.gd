extends RigidBody2D

signal shoot

enum State {
	INIT,
	ALIVE,
	INVULNERABLE,
	DEAD
}

export (int) var engine_power
export (int) var spin_power
export (PackedScene) var Bullet
export (float) var fire_rate

var state = null
var thrust = Vector2()
var rotation_dir = 0
var screensize = Vector2()
var shootable = true
var radius

func shoot():
	if state == State.INVULNERABLE:
		return

	emit_signal("shoot", Bullet, $PositionGun.global_position, rotation)
	shootable = false
	$TimerGun.start()

func handle_input():
	thrust = Vector2()

	if state in [State.INIT, State.DEAD]:
		return
	if Input.is_action_pressed("shoot") and shootable:
		shoot()
	if Input.is_action_pressed("thrust"):
		thrust = Vector2(engine_power, 0)

	rotation_dir = 0
	if Input.is_action_pressed("rotate_right"):
		rotation_dir += 1
	elif Input.is_action_pressed("rotate_left"):
		rotation_dir -= 1

func set_state(new_state):
	match new_state:
		State.INIT:
			$CollisionShape2D.disabled = true
		State.ALIVE:
			$CollisionShape2D.disabled = false
		State.INVULNERABLE:
			$CollisionShape2D.disabled = true
		State.DEAD:
			$CollisionShape2D.disabled = true

	state = new_state

func _on_TimerGun_timeout():
	shootable = true

func _integrate_forces(physics_state):
	set_applied_force(thrust.rotated(rotation))
	set_applied_torque(spin_power * rotation_dir)

	var xform = physics_state.get_transform()

	if xform.origin.x > screensize.x + radius:
		xform.origin.x = 0 - radius
	elif xform.origin.x < 0 - radius:
		xform.origin.x = screensize.x + radius
	if xform.origin.y > screensize.y + radius:
		xform.origin.y = 0 - radius
	elif xform.origin.y < 0 - radius:
		xform.origin.y = screensize.y + radius

	physics_state.set_transform(xform)

func _process(delta):
	handle_input()

func _ready():
	set_state(State.ALIVE)
	screensize = get_viewport().get_visible_rect().size
	$TimerGun.wait_time = fire_rate
	radius = int($Sprite.texture.get_size().x / 2)
