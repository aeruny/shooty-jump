extends AnimatableBody2D

var blow = false
var player: Node2D 
@export var strength: Vector2

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		blow = true
		player = body
		player.trampoline_touch = true
		player.trampoline_type = 5

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		blow = false
		player.trampoline_touch = false
		
func _process(delta: float) -> void:
	if blow == true:
		player.velocity -= strength
