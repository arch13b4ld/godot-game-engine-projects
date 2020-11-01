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

func hurt():
	$Sprite/AnimationPlayer.play("death")
	$CollisionShape.disabled = true
	set_physics_process(false)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'death':
		queue_free()

func _physics_process(delta):
	$Sprite.flip_h = facing == Direction.RIGHT
	velocity.y += gravity * delta
	velocity.x = facing * speed

	velocity = move_and_slide(velocity, up_direction)

	var slide_count = get_slide_count()
	for idx in range(slide_count):
		var collision = get_slide_collision(idx)
		var collider = collision.collider

		if collider.name == 'Player':
			collider.hurt()

		if collision.normal.x != 0 and is_on_wall():
			facing = sign(collision.normal.x)
			velocity.y = -100

	if position.y > 1000:
		queue_free()

func _ready():
	pass
