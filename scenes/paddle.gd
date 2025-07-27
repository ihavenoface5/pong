extends CharacterBody2D

@export var speed = 400

const initialPosition = Vector2(100, 240)
	
func _physics_process(_delta: float) -> void:
	velocity.x = 0
	position.x = initialPosition.x
	
	var direction = 0
	if Input.is_action_pressed("move_up"):
		direction += -1
	elif Input.is_action_pressed("move_down"):
		direction += 1
	velocity = Vector2(0, direction * speed)
	move_and_slide()

func reset() -> void:
	position = initialPosition
