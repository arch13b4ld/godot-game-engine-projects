extends KinematicBody2D

enum State {
	IDLE,
	RUN,
	JUMP,
	CLIMB,
	CROUCH,
	HURT,
	DEAD
}

var state
var anim
var new_anim

func set_state(new_state):
	state = new_state

	match state:
		State.IDLE:
			new_anim = 'idle'
		State.RUN:
			new_anim = 'run'
		State.HURT:
			new_anim = 'hurt'
		State.JUMP:
			new_anim = 'jump_up'
		State.CLIMB:
			new_anim = 'climb'
		State.CROUCH:
			new_anim = 'crouch'
		State.DEAD:
			hide()

func _physics_process(_delta):
	if new_anim != anim:
		anim = new_anim
		$Sprite/AnimationPlayer.play(anim)

func _ready():
	set_state(State.IDLE)
