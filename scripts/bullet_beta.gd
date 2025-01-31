extends AnimatableBody2D


var shot_angle
var spawn_position
var facing_scale
var speed = 400
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
		#print(collision.get_collider())
		if 'reflect' in collision.get_collider().to_string():
			
			velocity = velocity.bounce(collision.get_normal())
			rotation = velocity.angle()
			collision.get_collider().get_child(0).play("shine")
			if velocity.x < 0: #inconsistent
				$AnimatedSprite2D.set_flip_h(true) #gets sprite to flip
		elif 'Receptionist' in collision.get_collider().to_string() && !($"/root/StarterLevels/Receptionist".dead):
			$"../Receptionist"._shot()
		else:
		
			var wall_sound = AudioStreamPlayer2D.new()
			wall_sound.stream = $BulletGroundHitSound.stream
			wall_sound.global_position = global_position
			get_parent().add_child(wall_sound)
			wall_sound.play()
			
			# Create a Timer for the timeout
			var timeout_timer = Timer.new()
			timeout_timer.wait_time = 3
			timeout_timer.one_shot = true
			get_parent().add_child(timeout_timer)
			
			# Start the Timer
			timeout_timer.start()
			
			# Connect the Timer to stop the sound
			timeout_timer.connect("timeout", Callable(wall_sound, "stop"))
			
			# Optionally, clean up the sound player after stopping
			timeout_timer.connect("timeout", Callable(wall_sound, "queue_free"))
			timeout_timer.connect("timeout", Callable(timeout_timer, "queue_free"))
			
			queue_free()
			
	elif timer.get_time_left() == 0:
		queue_free()
