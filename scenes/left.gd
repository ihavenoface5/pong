extends Area2D

signal left_barrier_entered()

func _on_body_entered(body: Node2D) -> void:
	if (body.name == "Ball"):
		emit_signal("left_barrier_entered")
