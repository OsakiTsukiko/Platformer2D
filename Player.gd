extends KinematicBody2D

onready var rc_1 = $RC1
onready var rc_2 = $RC2

export var gravity: float = 1000

var velocity: Vector2 = Vector2.ZERO

func _physics_process(delta):
	velocity.y += gravity * delta
	
	var is_jump_interrupted = Input.is_action_just_released("jump") && velocity.y < 0.0
	
	velocity = move_and_slide(velocity, Vector2.ZERO)
