extends CharacterBody2D

const SPEED = 200.0
const TOPSPEED = 120.0
const SLOWINGSPEED = 600.0
const TURNINGSPEED = 1200.0
const MINSPEED = 10.0
const TRUE_MAX_SPEED = 100.0
const MAX_FALL = 350.0
const STANDUP_SPEED = 10.0
const JUMPWILD_SPIN_SPEED = 9.0
const JUMP_VELOCITY = -130.0
const DJUMP_VELOCITY = -200.0
const DJ_BOOST = 0.0
const COYOTEE_ALLOWANCE = 0.1
const MAX_JUMP_TIME = 0.3
const SHOT_VELOCITY = 6.5
const GROUND_SHOT_VELOCITY = 100

signal bullet_update

@onready var bullet_beta = preload("res://scenes/bullet_beta.tscn")
@onready var main = get_tree().get_root()
@onready var timer: Timer = $Timer

var not_started_jump = false
var has_double_jump = true
var ground_jump = false
var coyotee_time = 0
var effective_fall = MAX_FALL
var facingRight = true
var shots = 1
var max_shots = 1
var up_jump_time = 0
var state_machine # for animations

var trampoline_touch = false
var trampoline_type = 0

enum SpinTypes{
	POINT = 0,
	WILD_SPIN = 1,
	NO_SPIN = 2
}

# Mid-air_point behavior
var spin_type  = SpinTypes.NO_SPIN

# function for state machine
func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
	
# shoot a bullet relative to self
func shoot(direction):
	var bullet = bullet_beta.instantiate()
	bullet.shot_angle = rotation
	bullet.facing_scale = direction
	bullet.spawn_position = global_position + Vector2(10 * direction, -2).rotated(rotation)
	get_parent().add_child(bullet)
	emit_signal("bullet_update", -1)
	$PlayerGunSound.play()

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite: Sprite2D = $Sprite2D

func _physics_process(delta):

	# Input directions
	var direction = Input.get_axis("move_left", "move_right")
  
	$RunParticles.emitting = false

	# Start in air -------------------------------------------------------------------
	if trampoline_touch == true:
		
		if trampoline_type == 0:
			shots = max_shots
		elif trampoline_type == 1:
			shots = 0
		not_started_jump = false
		ground_jump = false
		has_double_jump = false
		state_machine.travel("jump") 
		spin_type = SpinTypes.POINT
		

		
	elif not is_on_floor():
		
		# If still have base jump, determine the coyotee factor
		if not_started_jump and ground_jump:
			coyotee_time += delta
			if coyotee_time > COYOTEE_ALLOWANCE:
				coyotee_time = 0
				ground_jump = false

		# Determine gravity
		if velocity.y < MAX_FALL:
			velocity.y += gravity * delta
			
			if velocity.y > MAX_FALL:
				velocity.y = MAX_FALL
		
		#Pointing type while in air 		
		if not not_started_jump:
			match spin_type:
				SpinTypes.POINT:
					rotate((get_local_mouse_position()).angle())
					
					if not facingRight:
						rotate(-PI)

				SpinTypes.WILD_SPIN:
					if facingRight:
						rotate(JUMPWILD_SPIN_SPEED * delta)
					else:
						rotate(-JUMPWILD_SPIN_SPEED * delta)
						
		# Old Air movement, disallow gaining momentum horizontally in air				
		#if direction != 0 and direction != velocity.sign().x:
			#velocity.x -= velocity.sign().x * SPEED * 0.5 * delta


		
		# New Air movement - move horizontally in air same as on ground
		# If moving character
		if direction:
			# If moving in direction of existing movement
			if direction == velocity.sign().x:
				if abs(velocity.x) < TOPSPEED:
					velocity.x += direction * SPEED * delta
				elif abs(velocity.x) < TOPSPEED:
					velocity.x = TOPSPEED * velocity.sign().x
			# When turning around/moving against existing movement
			else:
				velocity.x += direction * TURNINGSPEED * delta


	# End in air -------------------------------------------------------------------------

	# Start on floor -----------------------------------------------------------------------

	# Start on floor -----------------------------------------------------------------------
	else:
		
		if shots < 1:
			emit_signal("bullet_update", 1-shots)
		
		# Initiate from landing
		not_started_jump = true
		if not Input.is_action_pressed("jump"):
			ground_jump = true
			has_double_jump = true
		shots = max_shots
		
		# Standup - spin the shortest rotation, cutoff at 0.1 rads
		if rotation !=0:
			if rotation > 0:
				rotate(-STANDUP_SPEED * delta)
			elif rotation < 0:
				rotate(STANDUP_SPEED * delta)
			if abs(rotation) < 0.1:
					rotation = 0
		
		
		# Turning behavior
		# Turn around - turn right if not facing right, you press right, 
		# not pressing left			
		if (not facingRight and Input.is_action_pressed("move_right") 
			and not Input.is_action_pressed("move_left")):
			facingRight = true
			sprite.flip_h = false
			sprite.position.x = 4.0

		# Turn around - turn left if not facing left, you press left, 
		# not pressing right (and didnt turn right)			
		elif (facingRight and Input.is_action_pressed("move_left") 
			and not Input.is_action_pressed("move_right")):
			facingRight = false
			sprite.flip_h = true
			sprite.position.x = -4.0


		# If moving character
		if direction:
			
			state_machine.travel("walk")
			
			# If moving in direction of existing movement
			if direction == velocity.sign().x:
				if abs(velocity.x) < TOPSPEED:
					velocity.x += direction * SPEED * delta
					if abs(velocity.x) > TOPSPEED * 0.4:
						print(velocity)
						$RunParticles.emitting = true
				else:
					
					velocity.x = TOPSPEED * velocity.sign().x
			# When turning around/moving against existing movement
			else:
				velocity.x += direction * TURNINGSPEED * delta

		# If not moving character
		else:
			if abs(velocity.x) > 0:
				velocity.x -= velocity.sign().x * SLOWINGSPEED * delta
			else:
				state_machine.travel("idle")
	# End on floor ----------------------------------------------------------------------
		
		

	# Handle jump.
	if Input.is_action_pressed("jump"):
		
		
		# Ground Jump behavior
		if ground_jump:
			spin_type = SpinTypes.NO_SPIN
			velocity.y = JUMP_VELOCITY
			not_started_jump = false
			up_jump_time += 0.01
			if Input.is_action_just_pressed("jump"):
				$PlayerJumpSound.play()
			
		elif has_double_jump && Input.is_action_just_pressed("jump"):
			state_machine.travel("jump") 
			spin_type = SpinTypes.POINT
			velocity.y = DJUMP_VELOCITY
			not_started_jump = false
			has_double_jump = false
			velocity.x += DJ_BOOST * direction
			$PlayerDoubleJumpSound.play()

	  
	if up_jump_time > 0:
		up_jump_time += delta
		if up_jump_time > MAX_JUMP_TIME:
			up_jump_time = 0
			ground_jump = false
		elif not Input.is_action_pressed("jump"):
			ground_jump = false
			up_jump_time = 0
			
			
			
	if Input.is_action_just_pressed("Click"):
		if shots > 0 and not has_double_jump:
			state_machine.travel("shoot")
			if facingRight:
				velocity = (Vector2(-SHOT_VELOCITY, 0)).rotated(rotation)/delta
				shoot(1)
			else:
				velocity = (Vector2(SHOT_VELOCITY, 0)).rotated(rotation)/delta
				shoot(-1)
			shots -= 1
		elif timer.is_stopped() and has_double_jump:
			state_machine.travel("shoot")
			rotation = 0
			if facingRight:
				velocity = (Vector2(-GROUND_SHOT_VELOCITY, 0))
				shoot(1)
			else:
				velocity = (Vector2(GROUND_SHOT_VELOCITY, 0))
				shoot(-1)
			timer.start()
		#print(timer.time_left)
		
	# Continues to shoot for a distance to propel the player a certain amount
	#if timer.is_stopped() == false:
		#if facingRight:
		#	velocity += (Vector2(-SHOT_VELOCITY, 0)).rotated(rotation) / delta
		#else:
		#	velocity += (Vector2(SHOT_VELOCITY, 0)).rotated(rotation) / delta
		

	#if velocity.length() > TRUE_MAX_SPEED and (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
	#	velocity = velocity.normalized() * TRUE_MAX_SPEED
	# Stop movement if slow enough	
	
	if abs(velocity.x) < MINSPEED:
		velocity.x = 0
	if abs(velocity.y) < MINSPEED:
		velocity.y = 0

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
