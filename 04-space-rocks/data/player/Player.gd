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

func _ready():
	set_state(State.INIT)
