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

enum Action {
	LEFT,
	RIGHT,
	JUMP,
	CLIMB,
	CROUCH
}

export (int) var run_speed
export (int) var jump_speed
export (int) var gravity

var state
var anim
var new_anim

var velocity = Vector2()
var up_direction = Vector2(0, -1)

var input_actions = [
	'left',
	'right',
	'jump',
	'climb',
	'crouch']

func handle_input():
	if state == State.HURT:
		return

	velocity.x = 0

	var curr_action
	for action in input_actions:
		if action in [input_actions[Action.JUMP], input_actions[Action.CROUCH]]:
			curr_action = Input.is_action_just_pressed(action)
		else:
			curr_action = Input.is_action_pressed(action)

		if curr_action:
			if action == input_actions[Action.LEFT]:
				velocity.x -= run_speed
				$Sprite.flip_h = true
			elif action == input_actions[Action.RIGHT]:
				velocity.x += run_speed
				$Sprite.flip_h = false
			if action == input_actions[Action.JUMP] and is_on_floor():
				set_state(State.JUMP)
				velocity.y = jump_speed
#			if action == input_actions[Action.CLIMB]:
#				set_state(State.CLIMB)
#				velocity.y = jump_speed
#			if action == input_actions[Action.CROUCH]:
#				set_state(State.CROUCH)

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

func _physics_process(delta):
	velocity.y += gravity * delta

	handle_input()

	if state == State.IDLE and velocity.x != 0:
		set_state(State.RUN)
	elif state == State.RUN and velocity.x == 0:
		set_state(State.IDLE)

	if state in [State.IDLE, State.RUN] and !is_on_floor():
		set_state(State.JUMP)

	if new_anim != anim:
		anim = new_anim
		$Sprite/AnimationPlayer.play(anim)

	velocity = move_and_slide(velocity, up_direction)

	if state == State.JUMP and is_on_floor():
		set_state(State.IDLE)
	elif state == State.JUMP and velocity.y > 0:
		new_anim = 'jump_down'

func _ready():
	set_state(State.IDLE)
