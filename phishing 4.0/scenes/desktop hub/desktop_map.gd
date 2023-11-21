extends Node2D

var music_level = preload("res://scenes/music level/music_program_level.tscn")
@onready var player : CharacterBody2D = $Player
@onready var camera : Camera2D = $Player/Camera2D
@onready var canvas_desktop = $desktop
@onready var music_enterance : CollisionShape2D = $Area2D/CollisionShape2D
@onready var music_window = $desktop/window_music
@onready var blue_boarder = $desktop/remaining_blue
@onready var desktop_walls : CollisionPolygon2D = $Desktop_walls
@onready var desktop_hole : Sprite2D = $Sprite2D
@onready var position_node : Node2D = $position


var open_level = music_level.instantiate()

var are_in_level : bool = false

func _physics_process(_delta):
	if are_in_level == true:
		desktop_walls.disabled = true
		desktop_hole.visible = false
		music_window.visible = true
		music_enterance.disabled = true
		blue_boarder.visible = true
#		control.position.x = camera.position.x
#		control.position.y = camera.position.y
	else:
		camera.enabled = false
#	print(view.position.x)
	
	get_viewport_rect()


func _on_area_2d_body_entered(_body):
	#clip_mask.add_child(open_level)
	are_in_level = true
	position_node.add_child(open_level)
	camera.enabled = true
	player.queue_free()


#func _on_player_player_moved():
#	if are_in_level == true:
#		control.position.x = player.position.x + -300
#		control.position.y = player.position.y + -160
