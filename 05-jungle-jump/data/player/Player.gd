extends KinematicBody2D

signal life_changed
signal dead

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
export (int) var bounce_height
export (int) var bounce_lenght

var state setget set_state
var life setget set_life

var anim
var new_anim

var velocity = Vector2()
var up_direction = Vector2(0, -1)

var max_jumps = 2
var jump_count = 0

var input_actions = [
	'left',
	'right',
	'jump',
	'climb',
	'crouch'
]

func hurt():
	if self.state != State.HURT:
		self.state = State.HURT

func start(new_position):
	position = new_position
	show()

	self.state = State.IDLE
	self.life = 3

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

			if action == input_actions[Action.JUMP]:
				if state == State.JUMP and jump_count < max_jumps:
					self.state = State.JUMP
					velocity.y = jump_speed / 1.5
					jump_count += 1
				elif is_on_floor():
					self.state = State.JUMP
					velocity.y = jump_speed

#			if action == input_actions[Action.CLIMB]:
#				self.state = State.CLIMB
#				velocity.y = jump_speed

			if action == input_actions[Action.CROUCH] and is_on_floor():
				set_state(State.CROUCH)

func set_life(value):
	life = value
	emit_signal("life_changed", life)

func set_state(new_state):
	state = new_state

	match state:
		State.IDLE:
			new_anim = 'idle'
		State.RUN:
			new_anim = 'run'
		State.HURT:
			new_anim = 'hurt'
			velocity.y = bounce_height
			velocity.x = bounce_lenght * sign(velocity.x)
			self.life -= 1
			
			$AudioHurt.play()
			yield(get_tree().create_timer(0.5), "timeout")
			set_state(State.IDLE)

			if self.life <= 0:
				set_state(State.DEAD)
		State.JUMP:
			new_anim = 'jump_up'

			if jump_count >= max_jumps:
				jump_count = 1
	
			$AudioJump.play()
		State.CLIMB:
			new_anim = 'climb'
		State.CROUCH:
			new_anim = 'crouch'
		State.DEAD:
			hide()
			$CollisionShape.disabled = true
			set_physics_process(false)
			emit_signal("dead")

func _physics_process(delta):
	velocity.y += gravity * delta

	handle_input()

	if state == State.IDLE and velocity.x != 0:
		self.state = State.RUN
	elif state == State.RUN and velocity.x == 0:
		self.state = State.IDLE

	if state in [State.IDLE, State.RUN] and !is_on_floor():
		self.state = State.JUMP

	if new_anim != anim:
		anim = new_anim
		$Sprite/AnimationPlayer.play(anim)

	velocity = move_and_slide(velocity, up_direction)

	if state == State.HURT:
		return

	for idx in range(get_slide_count()):
		var collision = get_slide_collision(idx)
		var collider = collision.collider

		if collider.name == 'TileMapSpikes':
			hurt()

		if collider.is_in_group('enemies'):
			var player_feet = (position + $CollisionShape.shape.extents).y

			if player_feet < collider.position.y:
				collider.hurt()
				velocity.y = -200
			else:
				hurt()

	if state == State.JUMP and is_on_floor():
		self.state = State.IDLE
	elif state == State.JUMP and velocity.y > 0:
		new_anim = 'jump_down'

	if state == State.CROUCH and velocity.x != 0:
		self.state = State.RUN
	
	if position.y > 1000:
		self.state = State.DEAD

func _ready():
	self.state = State.IDLE
