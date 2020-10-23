extends RigidBody2D

signal exploded

export (float) var scale_factor
export (float) var mass_factor

var screensize = Vector2()
var explosion_scale = Vector2(0.75, 0.75)
var sprite_scale = Vector2(1, 1)
var radius = 0
var size

func explode():
	layers = 0
	
	$Sprite.hide()
	$Explosion/AnimationPlayer.play("explosion")
	emit_signal("exploded", size, radius, position, linear_velocity)
	
	linear_velocity = Vector2()
	angular_velocity = 0

func start(_position, velocity, _size):
	position = _position
	size = _size
	linear_velocity = velocity
	angular_velocity = rand_range(-1.5, 1.5)
	mass = mass_factor * size
	
	$Explosion.scale =  explosion_scale * size
	$Sprite.scale = sprite_scale * scale_factor * size
	radius = int($Sprite.texture.get_size().x / 2 * scale_factor * size)
	
	var shape = CircleShape2D.new()
	shape.radius = radius
	$CollisionShape2D.shape = shape

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()

func _integrate_forces(physics_state):
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

func _ready():
	pass
