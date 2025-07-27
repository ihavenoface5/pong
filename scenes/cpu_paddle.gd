extends CharacterBody2D

@onready
var ball = %Ball

var speed = 400

const initialPosition = Vector2(620, 240)

func _physics_process(_delta: float) -> void:
	if ball.position.y > position.y + 10:
		velocity.y = speed
	elif ball.position.y < position.y - 10:
		velocity.y = -speed
	else:
		velocity.y = 0
	position.x = initialPosition.x
	move_and_slide()

func reset() -> void:
	position = initialPosition
