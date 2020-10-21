extends Node

export (PackedScene) var Coin
export (PackedScene) var PowerUp
export (int) var gametime
export (int) var difficulty

var level
var score
var time_left
var screensize
var playing = false

func _ready():
	randomize()
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	$Player.hide()

func _process(delta):
	if playing and $CCoin.get_child_count() == 0:
		level += 1
		time_left += 5
		spawn_coins()
		$TPowerUp.wait_time = rand_range(5, 10)
		$TPowerUp.start()

func _on_TGame_timeout():
	time_left -= 1
	$HUD.update_timer(time_left)

	if time_left <= 0:
		game_over()

func _on_Player_pickup(type):
	match type:
		"coin":
			score += 1
			$ACoin.play()
			$HUD.update_score(score)
		"powerup":
			time_left += 5
			$APowerUp.play()
			$HUD.update_timer(time_left)

func _on_Player_hurt():
	game_over()

func _on_TPowerUp_timeout():
	var pu = PowerUp.instance()
	add_child(pu)
	pu.screensize = screensize
	pu.position = Vector2(rand_range(0, screensize.x), rand_range(0, screensize.y))

func new_game():
	playing = true
	level = 1
	score = 0
	time_left = gametime
	$Player.init($PlayerStart.position)
	$Player.show()
	$TGame.start()
	spawn_coins()
	$HUD.update_score(score)
	$HUD.update_timer(time_left)


func spawn_coins():
	$ALevel.play()
	for i in range(difficulty + level):
		var c = Coin.instance()
		$CCoin.add_child(c)
		c.screensize = screensize
		c.position = Vector2(rand_range(0, screensize.x), rand_range(0, screensize.y))

func game_over():
	$AGameOver.play()
	playing = false
	$TGame.stop()

	for coin in $CCoin.get_children():
		coin.queue_free()

	$HUD.show_game_over()
	$Player.end()
