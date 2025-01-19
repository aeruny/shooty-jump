extends AnimatableBody2D


var shot_angle
var spawn_position
var facing_scale


@onready var timer: Timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = spawn_position
	rotation = shot_angle
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	var collision = move_and_collide( Vector2(200 * facing_scale, 0).rotated(shot_angle) * delta )
	
	if collision:
		queue_free()
	elif timer.get_time_left() == 0:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	queue_free()
