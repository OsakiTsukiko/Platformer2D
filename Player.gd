extends KinematicBody2D

onready var ground_rc_1 = $RC1
onready var ground_rc_2 = $RC2

# PSEUDO CONSTANTS
export var GRAVITY_VEC: Vector2 = Vector2(0.0, 10000.0)
export var MAX_SPEED: Vector2 = Vector2(50000.0, 175000.0)
export var ACCELERATION: Vector2 = Vector2(7000.0, 0.0)
export var FRICTION: Vector2 = Vector2(7000.0, 0.0)
export var FLOOR_NORMAL: Vector2 = Vector2.UP # NOT A CONSTANT BUT EH
export var MAX_FALL_SPEED: float = 2000
# ^ this might be useful for weird gravity stuff
export var COYOTE_TIME: float = 0.1
export var AIR_JUMP_TIME: float = 0.1
export var VAR_JUMP_CONST: float = 30

# VARIABLES
var touching_ground: bool = false
var touching_wall: bool = false
var is_dashing: bool = false
var can_dash: bool = false
var is_coyote: bool = false
var air_jump_pressed: bool = false
var is_jumping: bool = false

var velocity: Vector2 = Vector2.ZERO

func _physics_process(delta):
	ground_checks()
	handle_input(delta)
	do_physics(delta)

func ground_checks() -> void:
	# checking for coyote time
	if (
		touching_ground && 
		!(ground_rc_1.is_colliding() || ground_rc_2.is_colliding())
	):
		touching_ground = false
		is_coyote = true
		yield(get_tree().create_timer(COYOTE_TIME), "timeout")
		is_coyote = false
	
	# check when player just touched the ground
	if (
		!touching_ground &&
		(ground_rc_1.is_colliding() || ground_rc_2.is_colliding())
	):
		# use a tween or sth to animate the character
		pass
	
	touching_ground = (ground_rc_1.is_colliding() || ground_rc_2.is_colliding())
	if (touching_ground):
		is_dashing = false
		can_dash = true
		is_jumping = false
		velocity.y = 0

func do_physics(delta: float):
	if (is_on_ceiling()):
		velocity.y = 10
		# ^ push back faster instead of floating
	
	if (!is_dashing):
		velocity.y += GRAVITY_VEC.y * delta
		velocity.y = min(velocity.y, MAX_FALL_SPEED)

	velocity = move_and_slide(velocity, FLOOR_NORMAL)
	
	print(velocity)
	
	# add tween animations

func handle_input(delta: float):
	
	# Handle Movement
	
	var input_vector: Vector2 = Vector2(
		float(Input.is_action_pressed("right")) - float(Input.is_action_pressed("left")),
		float(Input.is_action_pressed("down")) - float(Input.is_action_pressed("down"))
	)

#	velocity.x += input_vector.x * ACCELERATION.x * delta
#	if (abs(velocity.x) > SPEED.x):
#		velocity.x = sign(velocity.x) * SPEED.x
	if (abs(velocity.x) < MAX_SPEED.x * delta):
		velocity.x += input_vector.x * ACCELERATION.x * delta
	if (abs(velocity.x) >= MAX_SPEED.x * delta):
		velocity.x = input_vector.x * MAX_SPEED.x * delta
	
	if (input_vector.x == 0):
		velocity.x -= min(
			abs(velocity.x),
			FRICTION.x * delta
		) * sign(velocity.x)
	
	# Handle Jumping
	
	if (is_coyote && !is_jumping):
		if (Input.is_action_just_pressed("jump")):
			velocity.y = -1 * MAX_SPEED.y * delta
			is_jumping = true
	
	if (touching_ground):
		if (
			(
				Input.is_action_just_pressed("jump") ||
				air_jump_pressed
			)
		):
			velocity.y = -1 * MAX_SPEED.y * delta
			is_jumping = true
	
	if (!touching_ground):
		if (Input.is_action_just_released("jump") && velocity.y < 0.0):
			velocity.y *= min(VAR_JUMP_CONST * delta, 1)
		
		if (Input.is_action_just_pressed("jump")):
			air_jump_pressed = true
			yield(get_tree().create_timer(AIR_JUMP_TIME), "timeout")
			air_jump_pressed = false
