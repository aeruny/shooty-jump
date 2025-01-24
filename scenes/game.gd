extends Node2D

func _on_switch_body_entered(body: Node2D) -> void:
	if $switch/AnimatedSprite2D.frame == 0:
		$switch/AnimatedSprite2D.frame = 1
		$door/AnimationPlayer.play("open")
