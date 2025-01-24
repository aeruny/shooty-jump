extends AnimatableBody2D

var blow = false
var player: Node2D 

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		blow = true
		player = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		blow = false
		
func _process(delta: float) -> void:
	if blow == true:
		player.velocity -= Vector2(0,40)
