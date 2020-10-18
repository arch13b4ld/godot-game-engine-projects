extends CanvasLayer

signal start_game

func _ready():
	pass

func _process(delta):
	pass

func _on_TMessage_timeout():
	$LMessage.hide()

func _on_BStart_pressed():
	$BStart.hide()
	$LMessage.hide()
	emit_signal("start_game")

func update_score(value):
	$MarginContainer/LScore.text = str(value)

func update_timer(value):
	$MarginContainer/LTime.text = str(value)

func show_message(txt):
	$LMessage.text = txt
	$LMessage.show()
	$TMessage.start()

func show_game_over():
	show_message("Game Over")
	yield($TMessage, "timeout")
	$BStart.show()
	$LMessage.text = "Coin Dash!"
	$LMessage.show()
