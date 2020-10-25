extends Area2D

signal shoot

export (PackedScene) var Bullet
export (int) var speed
export (int) var health

var follow
var target = null

func _on_TimerGun_timeout():
	pass

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()

func _process(delta):
	follow.offset += speed * delta
	position = follow.global_position

	if follow.unit_offset > 1:
		queue_free()

func _ready():
	$Sprite.frame = randi() % ($Sprite.vframes * $Sprite.hframes)

	follow = PathFollow2D.new()
	follow.loop = false

	var path = $EnemyPaths.get_children()[randi() % $EnemyPaths.get_child_count()]
	path.add_child(follow)
