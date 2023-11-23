extends Node2D

@onready var p_camera = $Player/Camera2D
@onready var player = $Player
@onready var global = $"/root/Global"
@onready var playhead = $playhead
@onready var test = $CanvasLayer/Sprite2D
@onready var fade_timer = $fade_timer
@onready var splash_screen = $splash_screen
var stasis = false
@onready var original_position = player.position
var follow = 1
var program_open = false


func _ready():
	playhead.global_position.x = -309

	$AnimationPlayer.play("fade_in_splash")


func _physics_process(delta):
	print(original_position)
	if program_open == true:
		if $level_song.playing == false:
			$level_song.play()
		follow = p_camera.global_position.y
		playhead.position.x +=  2.0059027
		playhead.global_position.y = follow
		if playhead.global_position.x > 17031:
			playhead.global_position.x = -309





func _on_animation_player_animation_finished(fade_in_splash):
	program_open = true
