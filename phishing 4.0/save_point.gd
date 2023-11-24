extends Node2D


@onready var global = $"/root/Global"


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		global.update_spawn(self.global_position)
		print(global.music_spawn_point)
