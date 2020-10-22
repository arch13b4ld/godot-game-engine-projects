extends Node

var levels = ["res://levels/Level1.tscn", "res://levels/Level2.tscn"]
var start_screen = "res://ui/StartScreen.tscn"
var end_screen = "res://ui/EndScreen.tscn"
var current_level
var score = 0
var highscore = 0
var savefile = "user://escapethemaze"

func setup():
	var file = File.new()
	if file.file_exists(savefile):
		file.open(savefile, File.READ)
		var content = file.get_as_text()
		highscore = int(content)
		file.close()

func save_score():
	var file = File.new()
	file.open(savefile, File.WRITE)
	file.store_string(str(highscore))
	file.close()

func game_over():
	if score > highscore:
		highscore = score
		save_score()
	get_tree().change_scene(end_screen)

func next_level():
	current_level += 1

	if current_level >= Global.levels.size():
		game_over()
	else:
		get_tree().change_scene(levels[current_level])

func new_game():
	current_level = -1
	score = 0
	next_level()

func _process(delta):
	pass

func _ready():
	setup()
