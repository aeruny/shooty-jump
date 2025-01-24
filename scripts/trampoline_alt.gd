extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.velocity = body.get_real_velocity() * Vector2(1, -8)
