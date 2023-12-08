extends Node2D


@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	animated_sprite.play("idle")
	


func _on_static_body_2d_body_entered(body):
	if(body.name == "Player"):
		body.velocity.y = -500
		animated_sprite.play("bounce")
