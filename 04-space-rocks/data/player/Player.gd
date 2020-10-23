extends RigidBody2D

enum State {
	INIT,
	ALIVE,
	INVULNERABLE,
	DEAD
}

var state = null

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
