extends Area2D

signal coin_pickup

var textures = {'Coin': 'res://assets/coin.png',
				'KeyRed': "res://assets/keyRed.png",
				'Star': "res://assets/star.png"}
var type

func _ready():
	$Tween.interpolate_property($Sprite, 'scale', Vector2(1, 1), Vector2(3, 3),
		0.5,Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Sprite, 'modulate',
		Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.5,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)

func _on_Tween_tween_completed(object, key):
	queue_free()

func init(_type, pos):
	$Sprite.texture = load(textures[_type])
	type = _type
	position = pos

func pickup():
	match type:
		'Coin':
			emit_signal("coin_pickup", 1)
			$ACoin.play()
		'KeyRed':
			$AKey.play()

	$CollisionShape2D.disabled = true
	$Tween.start()

