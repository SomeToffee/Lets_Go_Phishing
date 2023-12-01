extends Area2D

#var player = preload("res://scenes/player/Player.tscn")
var used = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if used:
		$CollisionShape2D.disabled = true
	else:
		$CollisionShape2D.disabled = false



func _on_area_entered(area):
#	if area.name == "dash_refresh":
	print("refresh")
	used = true
	$AnimatedSprite2D.modulate.a = 0.1
	#player.can_dash = true
	await get_tree().create_timer(3).timeout
	used = false
	$AnimatedSprite2D.modulate.a = 1
