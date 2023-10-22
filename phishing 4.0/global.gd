extends Node2D


var music_spawn_point = Vector2(315, 180)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_spawn(new_spawn_point):
	music_spawn_point = new_spawn_point


func _physics_process(delta):
