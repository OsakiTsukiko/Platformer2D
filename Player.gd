extends KinematicBody2D

onready var rc_1 = $RC1
onready var rc_2 = $RC2

# PSEUDO CONSTANTS
export var GRAVITY_VEC := Vector2(0.0, 980.0)
export var SPEED := Vector2(150.0, 250.0)
export var FLOOR_NORMAL := Vector2.UP
# ^ this might be useful for weird gravity stuff
export var COYOTE_TIME: float = 0.1
export var AIR_JUMP_TIME: float = 0.1

# VARIABLES
var touching_ground: bool = false
var touching_wall: bool = false

var velocity: Vector2 = Vector2.ZERO

func _physics_process(delta):
	ground_checks()
	
	velocity += GRAVITY_VEC * delta
	
	var is_jump_interrupted = Input.is_action_just_released("jump") && velocity.y < 0.0
	
	velocity = move_and_slide(velocity, Vector2.ZERO)

func ground_checks() -> void:
	pass
