extends KinematicBody2D


var velocity = Vector2.ZERO
export var move_speed = 450
export var gravity = 1400
export var jump_force_ini = -550
export var long_jump_down = 15
var jump_force
var can_jump = false
var is_grounded
onready var raycasts = $Raycasts

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	
	_get_input()
	
	is_grounded = _check_is_grounded()
	
	_set_animator()
	
	if Input.is_action_just_pressed("jump"):
		if is_grounded:
			can_jump = true
			jump_force = jump_force_ini
	 
	if Input.is_action_just_released("jump"):
		can_jump = false

	if Input.is_action_pressed("jump"):
		if can_jump:
			jump_force += long_jump_down
			velocity.y = jump_force
	
	velocity = move_and_slide(velocity)

func _get_input():
	var move_direction = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	velocity.x = move_speed * move_direction
	if move_direction != 0:
		$Sprite.scale.x = move_direction
	
	$Camera2D.offset_h = move_direction
	
func _check_is_grounded():
	for raycast in raycasts.get_children():
		if raycast.is_colliding():
			return true
			
	return false
	
func _set_animator():
	var anim = "Idle"
	
	if !is_grounded:
		anim = "Jump"
	elif velocity.x != 0:
		anim = "Run"
	
	if $Anim.assigned_animation != anim:
		$Anim.play(anim)
		

