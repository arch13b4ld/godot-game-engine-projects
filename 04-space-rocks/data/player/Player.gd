extends RigidBody2D

signal shoot
signal lives_changed
signal dead
signal shield_changed

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
export (int) var max_shield
export (float) var shield_regen

var state = null
var thrust = Vector2()
var rotation_dir = 0
var screensize = Vector2()
var shootable = true
var radius
var lives = 0 setget set_lives
var shield = 0 setget set_shield

func start():
	$Sprite.show()
	self.lives = 3
	self.shield = max_shield
	set_state(State.ALIVE)

func set_shield(value):
	if value > max_shield:
		value = max_shield

	shield = value
	emit_signal("shield_changed", shield * 100 / max_shield)

	if shield <= 0:
		self.lives -= 1

		if lives <= 0:
			set_state(State.DEAD)
			explode(Vector2(1.5, 1.5))
		else:
			set_state(State.INVULNERABLE)
			explode(Vector2(1, 1))

func set_lives(value):
	lives = value
	self.shield = max_shield
	emit_signal("lives_changed", lives)

func explode(value):
		$Explosion.scale = value
		$Explosion.show()
		$Explosion/AnimationPlayer.play("explosion")

func shoot():
	if state == State.INVULNERABLE:
		return

	emit_signal("shoot", Bullet, $PositionGun.global_position, rotation)
	shootable = false
	$TimerGun.start()
	$AudioLaser.play()

func handle_input():
	thrust = Vector2()
	$Exhaust.emitting = false

	if state in [State.INIT, State.DEAD]:
		return
	if Input.is_action_pressed("shoot") and shootable:
		shoot()
	if Input.is_action_pressed("thrust"):
		thrust = Vector2(engine_power, 0)
		$Exhaust.emitting = true
		if not $AudioEngine.playing:
			$AudioEngine.play()
	else:
		$AudioEngine.stop()

	rotation_dir = 0
	if Input.is_action_pressed("rotate_right"):
		rotation_dir += 1
	elif Input.is_action_pressed("rotate_left"):
		rotation_dir -= 1

func set_state(new_state):
	match new_state:
		State.INIT:
			$CollisionShape2D.disabled = true
			$Sprite.modulate.a = 0.5
		State.ALIVE:
			$CollisionShape2D.disabled = false
			$Sprite.modulate.a = 1.0
		State.INVULNERABLE:
			$CollisionShape2D.disabled = true
			$Sprite.modulate.a = 0.5
			$TimerInvulnerability.start()
		State.DEAD:
			$CollisionShape2D.disabled = true
			$Sprite.hide()
			$AudioEngine.stop()
			linear_velocity = Vector2()
			emit_signal("dead")

	state = new_state

func _on_Player_body_entered(body):
	if body.is_in_group('rocks'):
		body.explode()
		explode(Vector2(0.5, 0.5))
		self.shield -= body.size * 25

func _on_AnimationPlayer_animation_finished(_anim_name):
	$Explosion.hide()

func _on_TimerInvulnerability_timeout():
	set_state(State.ALIVE)

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
	self.shield += shield_regen * delta

func _ready():
	set_state(State.INIT)
	$Sprite.hide()
	$TimerGun.wait_time = fire_rate
	radius = int($Sprite.texture.get_size().x / 2)
