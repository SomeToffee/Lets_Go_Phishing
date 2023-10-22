extends Node2D


var moving = false

func _on_area_2d_body_entered(body):
	if(body.name == "Player"):
		moving = true
		$AnimatableBody2D/AnimationPlayer.play("move")
