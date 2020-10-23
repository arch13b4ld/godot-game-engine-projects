extends Node

export (PackedScene) var Rock

var screensize = Vector2()
var base_velocity = Vector2(1, 0)

func spawn_rock(size, position=null, velocity=null):
	if !position:
		$PathRock/RockSpawn.set_offset(randi())
		position = $PathRock/RockSpawn.position

	if !velocity:
		velocity = base_velocity.rotated(rand_range(0, 2 * PI)) * rand_range(100, 150)
	
	var rock = Rock.instance()
	rock.screensize = screensize
	rock.start(position, velocity, size)
	$Rocks.add_child(rock)
	rock.connect('exploded', self, 'on_Rock_exploded')

func _on_Rock_exploded(size, radius, position, velocity):
	if size <= 1:
		return
	
	for offset in [-1, 1]:
		var direction = (position - $Player.position).normalized().tangent() * offset
		var new_position = position + direction * radius
		var new_velocity = direction * velocity.length() * 1.1
		
		spawn_rock(size - 1, new_position, new_velocity)

func _on_Player_shoot(scene, position, direction):
	var bullet = scene.instance()
	bullet.start(position, direction)
	add_child(bullet)

func _ready():
	randomize()

	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	
	for i in range(3):
		spawn_rock(3)
