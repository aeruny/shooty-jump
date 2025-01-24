extends AnimatableBody2D

@onready var player: CharacterBody2D = $"../Player"

var bounce = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if player.trampoline_shot == true:
		print("Bounce!")
		player.velocity = player.get_real_velocity() * Vector2(1, -2)# Replace with function body.
		

func _on_area_2d_body_exited(body: Node2D) -> void:
	player.trampoline_shot = false
	pass
