extends Node2D

@onready var p_camera = $Player/Camera2D
@onready var player = $Player
@onready var global = $"/root/Global"
@onready var playhead = $playhead
@onready var test = $CanvasLayer/Sprite2D
var follow = 1
var tween = create_tween()
#@onready var player = get_tree().get_root().get_node("/root/Player")
#@onready var playhead = $playhead
#
#var follow = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	playhead.global_position.x = -309

func _physics_process(delta):
	#print(player.global_position.y)
	print(playhead.global_position.x)
	
	
	follow = p_camera.global_position.y
#	tween.tween_property($playhead, "position", Vector2(11356, follow), 96)
	playhead.position.x +=  2.0059027
	playhead.global_position.y = follow
	if playhead.global_position.x > 17031:
		playhead.global_position.x = -309



