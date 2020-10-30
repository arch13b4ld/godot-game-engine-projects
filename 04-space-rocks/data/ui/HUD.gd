extends CanvasLayer

signal start_game

var lives_counter = []
onready var ShieldBar = $MarginContainer/HBoxContainer/ProgressShield
var red_bar = preload("res://assets/barHorizontal_red_mid 200.png")
var green_bar = preload("res://assets/barHorizontal_green_mid 200.png")
var yellow_bar = preload("res://assets/barHorizontal_yellow_mid 200.png")

func game_over():
	show_message("Game Over :(")
	yield($TimerMessage, "timeout")
	$ButtonStart.show()

func update_shieldbar(value):
	ShieldBar.texture_progress = green_bar
	if value < 40:
		ShieldBar.texture_progress = red_bar
	elif value < 70:
		ShieldBar.texture_progress = yellow_bar
	ShieldBar.value = value

func update_lives(value):
	for life in range(lives_counter.size()):
		lives_counter[life].visible = value > life

func update_score(value):
	$MarginContainer/HBoxContainer/LabelScore.text = str(value)

func show_message(message):
	$LabelMessage.text = message
	$LabelMessage.show()
	$TimerMessage.start()

func _on_TimerMessage_timeout():
	$LabelMessage.text = ""
	$LabelMessage.hide()

func _on_ButtonStart_pressed():
	$ButtonStart.hide()
	emit_signal("start_game")

func _ready():
	lives_counter = [
		$MarginContainer/HBoxContainer/LivesCounter/Life1,
		$MarginContainer/HBoxContainer/LivesCounter/Life2,
		$MarginContainer/HBoxContainer/LivesCounter/Life3,
	]
