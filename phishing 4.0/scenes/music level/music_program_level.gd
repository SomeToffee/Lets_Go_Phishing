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

#@onready var player = get_tree().get_root().get_node("/root/Player")
#@onready var playhead = $playhead
# 
#var follow = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	playhead.global_position.x = -309
	#var original_position = player.global_position
	#stasis = true
	
	fade_timer.start()

	$AnimationPlayer.play("fade_in_splash")
func _physics_process(delta):
#	if fade_timer.timeout:
#		stasis = false
#	if stasis == true:
#		player.global_position = original_position
#	if fade_timer.timeout:
#		player.move_lock = false
	print(original_position)
	#print(player.global_position.y)
	#print(playhead.global_position.x)
	splash_screen.position = player.position
	
	follow = p_camera.global_position.y
#	tween.tween_property($playhead, "position", Vector2(11356, follow), 96)
	playhead.position.x +=  2.0059027
	playhead.global_position.y = follow
	if playhead.global_position.x > 17031:
		playhead.global_position.x = -309



