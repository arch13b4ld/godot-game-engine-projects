extends CanvasLayer

signal start_game

var lives_counter = []

func update_lives(value):
	for life in range(lives_counter.size()):
		lives_counter[life].visible = value > life

func update_score(value):
	$MarginContainer/HBoxContainer/LabelScore.text = str(value)

func show_message(message):
	$LabelMessage.text = message
	$LabelMessage.show()
	$TimerMessage.start()

func _ready():
	lives_counter = [
		$MarginContainer/HBoxContainer/LivesCounter/Life1,
		$MarginContainer/HBoxContainer/LivesCounter/Life2,
		$MarginContainer/HBoxContainer/LivesCounter/Life3,
	]
