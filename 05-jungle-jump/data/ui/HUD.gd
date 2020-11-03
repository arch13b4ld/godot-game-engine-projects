extends MarginContainer

var heart_counter = []

func _on_Level_score_changed(value):
	$HBoxContainer/LabelScore.text = str(value)

func _on_Player_life_changed(value):
	for heart in range(heart_counter.size()):
		heart_counter[heart].visible = value > heart

func _ready():
	heart_counter = [
		$HBoxContainer/LifeCounter/Life1,
		$HBoxContainer/LifeCounter/Life2,
		$HBoxContainer/LifeCounter/Life3,
		$HBoxContainer/LifeCounter/Life4,
		$HBoxContainer/LifeCounter/Life5
	]
