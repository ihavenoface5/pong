extends Area2D

signal right_barrier_entered()

func _on_body_entered(body: Node2D) -> void:
	if (body.name == "Ball"):
		emit_signal("right_barrier_entered")
