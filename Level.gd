extends Node2D

onready var player = $Player
onready var spawn = $Spawn

func _process(delta):
	if Input.is_action_just_pressed("restart"):
		player.velocity = Vector2(0.0, 0.0)
		player.position = spawn.position
