extends "res://Scripts/character.gd"


# movements variables
var vel = Vector3()
var dir = Vector3()
var facing_direction = 0

# movements constants
const UP = Vector3(0,1,0)
const MAX_SPEED = 20
const ACCEL = 5
const DECCEL = 15
const JUMP_SPEED = 15
const  GRAVITY = -45



# Ammo variables
export var max_ammo = 5
var ammo = 0
var can_refill = false



# animation constans
const BLEND_MINIMUM = 0.8
const RUN_BLEND_AMOUNT = 0.1
const IDLE_BLEND_AMOUNT = 0.25
const RELOAD_BLEND_AMOUNT = 0.1
const ACTION_RESET_RATE = 0.05


# animation variables
var move_state = 0 # 0 is idle, 1 is run
var action_state = 0 # -1 is throw, 0 is idle, +1 is reload

func _ready():
	character_type = CHARACTER_TYPES.player
	if Costumisation.Player_materials != null:
		$Armature/Mesh.set_surface_material(0 , Costumisation.Player_materials)
	update_lives()

func _physics_process(delta):
	move(delta)
	face_forward()
	animate()
	refresh_refill_counter()

func move(delta):
	var movement_dir = get_2d_movement()
	var camera_transform = $Camera.get_global_transform()
	
	dir = Vector3(0,0,0)
	
	dir += camera_transform.basis.z.normalized() * movement_dir.y
	dir += camera_transform.basis.x.normalized() * movement_dir.x
	dir = move_vertically(dir, delta)
	vel = h_accel(dir,delta)
	move_and_slide(vel , UP)

func face_forward():
	$Armature.rotation.y = facing_direction


func get_2d_movement():
	var movement_vector = Vector2()
	if Input.is_action_pressed("forward") and not Input.is_action_pressed("backwards") :
		movement_vector.y = -1
		facing_direction = 0
	elif Input.is_action_pressed("backwards") and not Input.is_action_pressed("forward") :
		movement_vector.y = 1
		facing_direction = PI
	else:
		movement_vector.y = 0
	if Input.is_action_pressed("left") and not Input.is_action_pressed("right") :
		movement_vector.x = -1
		facing_direction =  PI * 0.5
	elif Input.is_action_pressed("right") and not Input.is_action_pressed("left") :
		movement_vector.x = 1
		facing_direction = PI *1.5
	else:
		movement_vector.x = 0
	return movement_vector.normalized()


func move_vertically(dir, delta):
	vel.y += GRAVITY * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		vel.y = JUMP_SPEED
	elif is_on_floor():
		vel.y = 0
		
	dir.y = 0
	dir = dir.normalized()
	return dir

func h_accel(dir, delta):
	var vel_2D = vel
	vel_2D.y = 0
	var target = dir
	target *= MAX_SPEED
	var accel
	if dir.dot(vel_2D) >0:
		accel = ACCEL
	else:
		accel = DECCEL
	vel_2D = vel_2D.linear_interpolate(target , accel * delta )
	vel.x = vel_2D.x
	vel.z = vel_2D.z
	return vel

func animate():
	var animate = $Armature/AnimationTreePlayer2
	if vel.length() > BLEND_MINIMUM:
		move_state += RUN_BLEND_AMOUNT
	else:
		move_state -= IDLE_BLEND_AMOUNT
	move_state = clamp(move_state,0,1)
	
	if can_refill:
		action_state += RELOAD_BLEND_AMOUNT
	action_state = clamp(action_state, -1, 1)
	action_state = lerp(action_state, 0, ACTION_RESET_RATE)
	
	animate.blend2_node_set_amount("Move", move_state )
	animate.blend3_node_set_amount("Action", action_state)



func _input(event):
	if Input.is_action_just_pressed("fire"):
		try_to_fire()



func try_to_fire():
	if can_fire and ammo>0:
		can_fire = false
		ammo -= 1
		$CanFire.start()
		fire()
		update_GUI()
		action_state = -1




func check_ammo_amount():
	if ammo < max_ammo:
		return true


func _on_CanRefill_timeout():
	if check_ammo_amount():
		ammo += 1
		update_GUI()


func RefillArea_enterd():
	if check_ammo_amount():
		$RefillTimer.start()
		can_refill = true
		$Harp.play()

func RefillArea_exited():
	$RefillTimer.stop()
	can_refill = false
	$Harp.stop()
	

func update_GUI(): 
	get_tree().call_group("GUI","refresh_AmmoCount" ,ammo)

func refresh_refill_counter():
	if can_refill:
		var refill_time_left = $RefillTimer.wait_time - $RefillTimer.time_left
		get_tree().call_group("GUI","Refill",refill_time_left )
	else:
		get_tree().call_group("GUI","Refill",0 )

func die():
	get_tree().change_scene("res://Scenes/GUI/GameOver/GameOver.tscn")


