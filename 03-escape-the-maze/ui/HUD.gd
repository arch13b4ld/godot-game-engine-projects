extends CanvasLayer

func update_score(value):
	Global.score += value
	$MarginContainer/LScore.text = str(Global.score)

func _ready():
	update_score(0)
