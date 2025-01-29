extends Area2D

@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("You died!")
		$PlayerDeathSound.play()
		Engine.time_scale = 0.5
		$"../../Player".control = false
		timer.start()


func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	$"/root/StarterLevels".respawn()
