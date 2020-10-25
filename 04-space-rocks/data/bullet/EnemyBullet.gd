extends "res://data/bullet/Bullet.gd"

func _on_EnemyBullet_body_entered(body):
	queue_free()

func _ready():
	pass



