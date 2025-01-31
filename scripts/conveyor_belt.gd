extends AnimatableBody2D


var move = false
var object
@export var speed: Vector2 = Vector2(0,0)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		move = true
		object = body


func _on_area_2d_body_exited(body: Node2D) -> void:
	move = false
	object = null


func _process(delta: float) -> void:
	if move == true && object.is_on_floor():
		object.position += speed
		
func play_first():
	$AudioStreamPlayer2D.play()
	
func play_second():
	$AudioStreamPlayer2D2.play()
