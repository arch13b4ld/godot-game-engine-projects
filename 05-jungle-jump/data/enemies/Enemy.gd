extends KinematicBody2D

enum Direction {
	LEFT = -1,
	RIGHT = 1
}

export (int) var gravity
export (int) var speed

var velocity = Vector2()
var up_direction = Vector2(0, -1)
var facing = Direction.RIGHT

func _physics_process(delta):
	$Sprite.flip_h = velocity.x > 0
	velocity.y += gravity * delta
	velocity.x = facing * speed

	velocity = move_and_slide(velocity, up_direction)

	for idx in range(get_slide_count()):
		var collision = get_slide_collision(idx)

		if collision.collider.name == 'Player':
			collision.collider.hurt()

		if collision.normal.x != 0:
			facing = sign(collision.normal.x)
			velocity.y = -100

	if position.y > 1000:
		queue_free()

func _ready():
	pass
