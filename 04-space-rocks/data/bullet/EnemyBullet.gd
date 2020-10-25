extends Area2D

export (int) var speed

var velocity = Vector2()

func start(_position, direction):
	position += _position
	velocity = Vector2(speed, 0).rotated(direction)
	rotation = direction

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_EnemyBullet_body_entered(_body):
	queue_free()

func _process(delta):
	position += velocity * delta

func _ready():
	pass
