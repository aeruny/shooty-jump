extends CharacterBody2D

const SPEED = 200.0
const TOPSPEED = 220.0
const SLOWINGSPEED = 600.0
const TURNINGSPEED = 1200.0
const JUMP_VELOCITY = -400.0
const DJUMP_VELOCITY = -200.0
const MAX_FALL = 350.0
const MINSPEED = 10.0
const DJ_BOOST = 100.0
const COYOTEE_ALLOWANCE = 0.4
const STANDUP_SPEED = 10
const JUMPSPIN_SPEED = 9
const SHOT_VELOCITY = 200.0

const TRUE_MAX_SPEED = 500

#@onready var sprite = get_node("NewPiskel-1_png")
#@onready var shooter = get_node("Shooter")
@onready var bullet_beta = preload("res://scenes/bullet_beta.tscn")
@onready var main = get_tree().get_root()

var landed = false
var double_jump = true
var ground_jump = false
var coyotee_time = 0
var effective_fall = MAX_FALL
var facingRight = true
var shots = 3

enum SpinTypes{
	POINT = 0,
	SPIN = 1
}

var spin_type  = SpinTypes.POINT



func shoot(direction):
	var bullet = bullet_beta.instantiate()
	bullet.shot_angle = rotation
	bullet.facing_scale = direction
	bullet.spawn_position = global_position + Vector2(10 * direction, -2).rotated(rotation)
	get_parent().add_child(bullet)
	$PlayerGunSound.play()

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		if ground_jump:
			coyotee_time += delta
			if coyotee_time > COYOTEE_ALLOWANCE:
				coyotee_time = 0
				ground_jump = false
		if velocity.y <= MAX_FALL:
			velocity.y += gravity * delta
			if velocity.y > MAX_FALL:
				velocity.y = MAX_FALL
			if not landed:
				match spin_type:
					SpinTypes.POINT:
						rotate((get_local_mouse_position()).angle())
						if not facingRight:
							rotate(-PI)
					SpinTypes.SPIN:
						if facingRight:
							rotate(JUMPSPIN_SPEED * delta)
						else:
							rotate(-JUMPSPIN_SPEED * delta)
	
	$RunParticles.emitting = false
						
	var direction = Input.get_axis("move_left", "move_right")
	
	if is_on_floor():
		
		ground_jump = true
		double_jump = true
		landed = true
		shots = 3
		
		if rotation !=0:
			if rotation > 0:
				rotate(-STANDUP_SPEED * delta)
			elif rotation < 0:
				rotate(STANDUP_SPEED * delta)
			
			if abs(rotation) < 0.1:
					rotation = 0
					
		if (not facingRight and Input.is_action_pressed("move_right") 
			and not Input.is_action_pressed("move_left")):
			facingRight = true
			animated_sprite.flip_h = false
			animated_sprite.position.x = 4.0

			#sprite.flip(direction)
			#shooter.flip(direction)
			
		elif (facingRight and Input.is_action_pressed("move_left") 
			and not Input.is_action_pressed("move_right")):
			facingRight = false
			animated_sprite.flip_h = true
			animated_sprite.position.x = -4.0

			#sprite.flip(direction)
			#shooter.flip(direction)
		
		if direction:
			
			animated_sprite.play("run")	
			if direction == velocity.sign().x:
				if abs(velocity.x) < TOPSPEED:
					velocity.x += direction * SPEED * delta
					if abs(velocity.x) > TOPSPEED * 0.4:
						print(velocity)
						$RunParticles.emitting = true
				else:
					
					velocity.x = TOPSPEED * velocity.sign().x
			else:
				velocity.x += direction * TURNINGSPEED * delta
			

			
			if abs(velocity.x) < MINSPEED:
				velocity.x = 0
			
			
		else:
			animated_sprite.play("jump")
			
			velocity.x -= velocity.sign().x * SLOWINGSPEED * delta
			
			if abs(velocity.x) < MINSPEED:
				velocity.x = 0
	
	else:
		animated_sprite.play("idle")
		if direction != 0 and direction != velocity.sign().x:
			velocity.x -= velocity.sign().x * SPEED * 0.5 * delta
			
		if abs(velocity.x) < MINSPEED:
				velocity.x = 0

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		if ground_jump:
			spin_type = SpinTypes.POINT
			velocity.y = JUMP_VELOCITY
			ground_jump = false
			landed = false
			$PlayerJumpSound.play()
			
		elif double_jump:
			spin_type = SpinTypes.SPIN
			velocity.y = DJUMP_VELOCITY
			landed = false
			double_jump = false
			velocity.x += DJ_BOOST * direction
			$PlayerDoubleJumpSound.play()
			
	if shots > 0 and Input.is_action_just_pressed("Click"):
		if facingRight:
			velocity += (Vector2(-SHOT_VELOCITY, 0)).rotated(rotation)
			shoot(1)
		else:
			velocity += (Vector2(SHOT_VELOCITY, 0)).rotated(rotation)
			shoot(-1)
		shots -= 1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

	if velocity.length() > TRUE_MAX_SPEED:
		velocity = velocity.normalized() * TRUE_MAX_SPEED

	move_and_slide()

func get_floor_color(position: Vector2) -> Color:
	# Get the floor node (assume it is a Sprite or has a texture)
	var floor = $Floor  # Replace with the actual path to your floor node

	if floor is Sprite2D and floor.texture:
		var texture = floor.texture
		var tex_data = texture.get_data()
		tex_data.lock()  # Lock the texture data to read pixel colors
		
		# Convert world position to texture coordinates
		var tex_coords = (position - floor.global_position) / floor.scale
		tex_coords.x = clamp(tex_coords.x, 0, texture.get_width() - 1)
		tex_coords.y = clamp(tex_coords.y, 0, texture.get_height() - 1)
		
		var color = tex_data.get_pixelv(tex_coords)
		tex_data.unlock()
		
		return color
	return Color(1, 1, 1)  # Default color if no texture is found
