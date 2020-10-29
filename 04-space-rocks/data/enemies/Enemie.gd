extends Area2D

signal shoot

export (PackedScene) var Bullet
export (int) var speed
export (int) var health

var follow
var target = null

func damage(amount):
	health -= amount
	$AnimationPlayer.play("flash")

	if health <= 0:
		explode()

	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("spin")

func explode():
	speed = 0
	$AudioExplosion.play()
	$TimerGun.stop()
	$CollisionShape2D.disabled = true
	$Sprite.hide()
	$Explosion.show()
	$Explosion/AnimationPlayer.play("explosion")
#	$AExplosion.play()

func shoot_pulse(n, delay):
	for _i in range(n):
		shoot()
		yield(get_tree().create_timer(delay), "timeout")

func shoot():
	var direction = target.global_position - global_position
	direction = direction.rotated(rand_range(-0.1, 0.1)).angle()
	$AudioShoot.play()
	emit_signal("shoot", Bullet, global_position, direction)

func _on_Enemie_body_entered(body):
	if body.name == 'Player':
		pass
	explode()

func _on_TimerGun_timeout():
	shoot_pulse(3, 1.5)

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()

func _process(delta):
	follow.offset += speed * delta
	position = follow.global_position

	if follow.unit_offset >= 1:
		queue_free()

func _ready():
	$Sprite.frame = randi() % ($Sprite.vframes * $Sprite.hframes)

	follow = PathFollow2D.new()
	follow.loop = false

	var path = $EnemyPaths.get_children()[randi() % $EnemyPaths.get_child_count()]
	path.add_child(follow)
