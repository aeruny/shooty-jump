extends AnimatableBody2D


var shot_angle
var spawn_position
var facing_scale
var speed = 200
var velocity
@onready var timer: Timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = spawn_position
	rotation = shot_angle
	velocity = Vector2(speed * facing_scale, 0).rotated(shot_angle)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	var collision = move_and_collide( velocity * delta )
	if collision:
		print(collision.get_collider())
		if 'reflect' in collision.get_collider().to_string():
			velocity = velocity.bounce(collision.get_normal())
		else:
			queue_free()

	if timer.get_time_left() == 0:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.name.match("reflect"):
		print('hi')
	else:
		queue_free()
