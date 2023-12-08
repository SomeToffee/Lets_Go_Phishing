extends Node2D

@onready var button = $Button
#@onready var player = get_tree().get_node("res://scenes/player/Player.tscn")


func _process(_delta):
	if Input.is_action_just_pressed("dash"):
		button.modulate.a = lerpf(modulate.a,0.5,1)
		await get_tree().create_timer(0.5).timeout
		button.modulate.a = lerpf(modulate.a,1,0.1)
