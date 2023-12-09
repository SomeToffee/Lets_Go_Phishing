extends CharacterBody2D


@export var speed : float = 200
@export var jump_velocity : float = -300.0
@export var wall_jump_pushback : float = 500
@export var wall_slide_gravity : float = 50
@export var wall_sliding : bool = false
@export var gravity : float = 700
@export var dash_speed = 700
@export var HP = 3
#dash stuff


var follow = 1
var is_dashing : bool = false # check if we're dashing
@export var can_dash : bool = true # check if we can dash? 
var is_wall_jumping : bool = false
var move_lock : bool = false
var is_bold : bool = false
var invincible : bool = false
var hit_lock : bool = false
var is_dashing_bold : bool = false
#var dash_direction : Vector2 # get the direction we'll dash in
#var dash_direction = Vector2(1, 0)
var last_moved_dir = "start"
var got_hit = false
#signal player_moved


@onready var animated_sprite_roll : AnimatedSprite2D = $roll
@onready var animated_sprite_idle : AnimatedSprite2D = $idle
@onready var animated_sprite_wall_splat : AnimatedSprite2D = $wall_splat
@onready var animated_sprite_wall_splat_left : AnimatedSprite2D = $wall_splat_left
@onready var cayote_time = $cayote_time
@onready var global = $"/root/Global"
# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var animation_locked : bool = false
var direction : Vector2 = Vector2.ZERO
var dash_direction : Vector2 = Vector2.ZERO
@export var facingDirection = Vector2.RIGHT
@export var stop = false
var input_vector = Vector2.ZERO
#var player_scale = self.scale.x
#func _ready():# -> void:
#	self.position = global.music_spawn_point


func _physics_process(delta):
	#print(self.modulate.g)
	#print(delta)
	if stop == true:
		animated_sprite_roll.play("roll")
	if stop == false:
		var was_on_floor = is_on_floor()
		
		fish_hurtbox_manager()
		move_and_slide()
		
		if was_on_floor and !is_on_floor():
			cayote_time.start()
		
		if move_lock == true:
			await get_tree().create_timer(0.2).timeout
			move_lock = false
		# Handle Jump.
		if Input.is_action_just_pressed("jump"):
			if is_on_floor() || !cayote_time.is_stopped():
				velocity.y = jump_velocity
			if is_on_wall() and !is_on_floor():
				move_lock = true
				# Determine the wall jump direction based on player input.
				var wall_jump_direction = Vector2.ZERO
				if last_moved_dir == "left":
					wall_jump_direction.x = 1  # Jump to the right
				elif last_moved_dir == "right":
					wall_jump_direction.x = -1  # Jump to the left
				wall_jump_direction.y = -1  # Jump upward

				# Apply the wall jump force.
				velocity = wall_jump_direction.normalized() * wall_jump_pushback
				#print(velocity.x)
		
		
		if is_dashing == false or is_dashing_bold == true:
			if not is_on_floor():
				velocity.y += gravity * delta
			direction = Input.get_vector("left", "right", "up", "down")
			
			
			if move_lock == false and hit_lock == false:
				if direction:
					velocity.x = direction.x * speed
				velocity.x *= 0.9
#				else:
#					velocity.x = move_toward(velocity.x, 0, 0.5)
		if got_hit == true:
			got_hit = false
			getting_hit()
#		wall_stick()
		facing_direction()
		update_animation()
		handle_dash(delta)
		bold()
		wall_slide(delta)
		player_flip()

		
func update_animation():
	if not animation_locked:
		if !is_on_wall():
			if direction.x != 0:
				animated_sprite_roll.visible = true
				animated_sprite_idle.visible = false
				animated_sprite_wall_splat.visible = false
				animated_sprite_wall_splat_left.visible = false
				animated_sprite_roll.play("roll")
			elif direction.x == 0 and !is_on_floor() and !is_on_wall():
#				if last_moved_dir == "left":
#					animated_sprite_idle.flip_h = true
#				else:
#					animated_sprite_idle.flip_h = false
				animated_sprite_roll.visible = true
				animated_sprite_idle.visible = false
				animated_sprite_wall_splat.visible = false
				animated_sprite_wall_splat_left.visible = false
				animated_sprite_roll.play("roll")
			else:
#				if last_moved_dir == "left":
#					animated_sprite_idle.flip_h = true
#				else:
#					animated_sprite_idle.flip_h = false
				animated_sprite_roll.visible = false
				animated_sprite_idle.visible = true
				animated_sprite_wall_splat.visible = false
				animated_sprite_wall_splat_left.visible = false
				animated_sprite_idle.play("idle")
		if is_on_wall() and !is_on_floor():
			if last_moved_dir == "right" and !animated_sprite_wall_splat_left.visible:
				animated_sprite_roll.visible = false
				animated_sprite_idle.visible = false
				animated_sprite_wall_splat.visible = true
				animated_sprite_wall_splat_left.visible = false
				animated_sprite_wall_splat.play("default")
				await get_tree().create_timer(0.2).timeout
				animated_sprite_wall_splat.set_frame(2)
			if last_moved_dir == "left" and !animated_sprite_wall_splat.visible:
				animated_sprite_roll.visible = false
				animated_sprite_idle.visible = false
				animated_sprite_wall_splat.visible = false
				animated_sprite_wall_splat_left.visible = true
				animated_sprite_wall_splat_left.play("default")
				await get_tree().create_timer(0.2).timeout
				animated_sprite_wall_splat_left.set_frame(2)

func facing_direction():
	if Input.is_action_pressed("right"):
		input_vector.x = 1
	if Input.is_action_pressed("left"):
		input_vector.x = -1

	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()
	#print(input_vector)
	if direction.x > 0:
		last_moved_dir = "right"
	if direction.x < 0:
		last_moved_dir = "left"

func player_flip():
	if last_moved_dir == "left":
		animated_sprite_idle.flip_h = true
		animated_sprite_roll.flip_h = true
	if last_moved_dir == "right":
		animated_sprite_idle.flip_h = false
		animated_sprite_roll.flip_h = false

func handle_dash(delta):
	if is_on_floor() or is_on_wall():
		can_dash = true

	dash_direction = Input.get_vector("left", "right", "up", "down")
		
		
	if Input.is_action_just_pressed("dash") and can_dash:
		if dash_direction == Vector2(0, 0):
			await get_tree().create_timer(0.05).timeout
			dash_direction = Input.get_vector("left", "right", "up", "down")
			if dash_direction == Vector2(0, 0):
				dash_direction = facingDirection
		velocity = dash_direction.normalized() * dash_speed
		print("dash")
		can_dash = false
		is_dashing = true
		await get_tree().create_timer(0.2).timeout
		if is_dashing_bold == false:
			velocity = velocity * 0.1
			is_dashing = false

func wall_slide(delta):
	if is_on_wall() and !is_on_floor():
		if Input.is_action_pressed("right") or Input.is_action_pressed("left"):
			wall_sliding = true
		else:
			wall_sliding = false
	else:
		wall_sliding = false
		
	if wall_sliding:
		velocity.y += (wall_slide_gravity * delta)
		velocity.y = min(velocity.y, wall_slide_gravity)

func bold():
	if Input.is_action_just_pressed("bold") and is_dashing == false:
		is_bold = true
		#print("yes")
	if Input.is_action_just_pressed("bold") and is_dashing == true:
		is_dashing_bold = true
	if Input.is_action_just_released("bold") and is_bold:
		is_bold = false
	

		
		
		
		
	
	if is_bold == false:
		#move_lock = false
		self.modulate.g = 1
		
	if is_bold == true:
		print("bold")
		move_lock = true
		velocity.y = 2000
		velocity.x = 0
		self.modulate.g = 0

#hurtbox

func _on_hurt_box_body_entered(body):
	got_hit = true
	
func _input(event : InputEvent):
	if(event.is_action_pressed("down")):
		position.y += 1

func frame_freeze(time_control, duration):
	Engine.time_scale = time_control
	await get_tree().create_timer(duration * time_control).timeout
	Engine.time_scale = 1
	
func getting_hit():
	if invincible == false:
		HP = HP - 1
		print(HP)
		invincible = true
		
		
		if HP > 0:
			frame_freeze(0.005, 0.9)
			hit_lock = true
			var knock_back = 300
			if direction.x > 0:
				velocity.x = -knock_back
				velocity.y = -knock_back
			elif direction.x < 0:
				velocity.x = knock_back
				velocity.y = -knock_back
			elif direction.x == 0:
				velocity.y = -knock_back
			await get_tree().create_timer(0.5).timeout
			hit_lock = false
		if HP < 1:
			
			self.global_position = global.music_spawn_point
			HP = 3
	await get_tree().create_timer(1).timeout
	invincible = false

func fish_hurtbox_manager():
	if animated_sprite_idle.visible == true:
		$idle_collision.disabled = false
		$hurt_box/idle_box.disabled = false
		$roll_collision.disabled = true
		$hurt_box/roll_box.disabled = true
		$wall_splat_collison.disabled = true
		$hurt_box/wall_splat_box.disabled = true
		$wall_splat_collison_left.disabled = true
		$hurt_box/wall_splat_box_left.disabled = true
	elif animated_sprite_roll.visible == true:
		$idle_collision.disabled = true
		$hurt_box/idle_box.disabled = true
		$roll_collision.disabled = false
		$hurt_box/roll_box.disabled = false
		$wall_splat_collison.disabled = true
		$hurt_box/wall_splat_box.disabled = true
		$wall_splat_collison_left.disabled = true
		$hurt_box/wall_splat_box_left.disabled = true
	elif animated_sprite_wall_splat.visible == true:
		$idle_collision.disabled = true
		$hurt_box/idle_box.disabled = true
		$roll_collision.disabled = true
		$hurt_box/roll_box.disabled = true
		$wall_splat_collison.disabled = false
		$hurt_box/wall_splat_box.disabled = false
		$wall_splat_collison_left.disabled = true
		$hurt_box/wall_splat_box_left.disabled = true
	elif animated_sprite_wall_splat_left.visible == true:
		$idle_collision.disabled = true
		$hurt_box/idle_box.disabled = true
		$roll_collision.disabled = true
		$hurt_box/roll_box.disabled = true
		$wall_splat_collison.disabled = true
		$hurt_box/wall_splat_box.disabled = true
		$wall_splat_collison_left.disabled = false
		$hurt_box/wall_splat_box_left.disabled = false

#func wall_stick():
#	if animated_sprite_wall_splat.visible and Input.is_action_just_pressed("left"):
#		velocity.x = 0
#func get_which_wall_collided():
#	for i in range(get_slide_collision_count()):
#		var collision = get_slide_collision(i)
#		if collision.normal.x > 0:
#			return "left"
#		elif collision.normal.x < 0:
#			return "right"


func _on_dash_refresh_area_entered(area):
	can_dash = true
