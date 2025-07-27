extends RigidBody2D

var initialSpeed = 300
var speed

const maxSpeed = 1000
const minXAngle = PI / 4
const initialPosition = Vector2(360, 240)

var increaseSpeedOnCollision = true
var pendingReset = false

signal ball_collided_with_paddle()

func _ready():
	gravity_scale = 0
	contact_monitor = true
	reset()
	
func _integrate_forces(state):
	if (pendingReset):
		_resetPosition()
		pendingReset = false
	else:
		_updateVelocity()

func _resetPosition() -> void:
	position = initialPosition
	linear_velocity = Vector2.ZERO
	angular_velocity = 0

func _updateVelocity() -> void:
	if linear_velocity == Vector2.ZERO:
		return
	
	var updatedVelocity = linear_velocity.normalized()
	if abs(updatedVelocity.x) < minXAngle:
		updatedVelocity.x = minXAngle if updatedVelocity.x > 0 else -minXAngle
	linear_velocity = updatedVelocity * speed

func _ballCollidedWithBody(state: PhysicsDirectBodyState2D) -> bool:
	for i in range(state.get_contact_count()):
		var collider = state.get_contact_collider_object(i)
		if collider is CharacterBody2D:
			return true
	return false

func _updateBallSpeed() -> void:
	speed = min(speed + 50, maxSpeed)

func reset() -> void:
	pendingReset = true if linear_velocity != Vector2.ZERO else false
	speed = initialSpeed
	
func launch() -> void:
	linear_velocity = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * speed

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		emit_signal("ball_collided_with_paddle")
		if increaseSpeedOnCollision:
			_updateBallSpeed()
