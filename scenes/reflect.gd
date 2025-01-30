extends StaticBody2D

var velocity

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity = Vector2(0, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	var collision = move_and_collide( velocity * delta )
	if collision:
		print(collision.get_collider())
		if 'bullet' in collision.get_collider().to_string():
			$AnimatedSprite2D.play("shine")
