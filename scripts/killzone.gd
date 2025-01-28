extends Area2D

@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("You died!")
		$PlayerDeathSound.play()
		body.get_node("CollisionShape2D").queue_free()
		timer.start()
	else:
		body.queue_free()


func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
