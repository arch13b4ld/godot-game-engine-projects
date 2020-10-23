extends RigidBody2D

enum State {
	INIT,
	ALIVE,
	INVULNERABLE,
	DEAD
}

export (int) var engine_power
export (int) var spin_power

var state = null
var thrust = Vector2()
var rotation_dir = 0
var screensize = Vector2()

func handle_input():
	thrust = Vector2()

	if state in [State.INIT, State.DEAD]:
		return
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

func _integrate_forces(physics_state):
	set_applied_force(thrust.rotated(rotation))
	set_applied_torque(spin_power * rotation_dir)

	var xform = physics_state.get_transform()

	if xform.origin.x > screensize.x:
		xform.origin.x = 0
	elif xform.origin.x < 0:
		xform.origin.x = screensize.x
	if xform.origin.y > screensize.y:
		xform.origin.y = 0
	elif xform.origin.y < 0:
		xform.origin.y = screensize.y

	physics_state.set_transform(xform)

func _process(delta):
	handle_input()

func _ready():
	set_state(State.ALIVE)
	screensize = get_viewport().get_visible_rect().size
