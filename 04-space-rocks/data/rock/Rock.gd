extends RigidBody2D

export (float) var scale_factor
export (float) var mass_factor

var screensize = Vector2()
var base_scale = Vector2(1, 1)
var size
var radius

func start(_position, velocity, _size):
	position = _position
	linear_velocity = velocity
	size = _size
	angular_velocity = rand_range(-1.5, 1.5)
	mass = mass_factor * size
	
	$Sprite.scale = base_scale * scale_factor * size
	radius = int($Sprite.texture.get_size().x / 2 * scale_factor * size)
	
	var shape = CircleShape2D.new()
	shape.radius = radius
	$CollisionShape2D.shape = shape

func _ready():
	pass
