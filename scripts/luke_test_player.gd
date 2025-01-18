extends CharacterBody2D


const SPEED = 200.0
const TOPSPEED = 220.0
const SLOWINGSPEED = 600.0
const TURNINGSPEED = 1200.0
const JUMP_VELOCITY = -400.0
const DJUMP_VELOCITY = -200.0
const MAX_FALL = 350
const MINSPEED = 10

@onready var sprite = get_node("NewPiskel-1_png")
@onready var shooter = get_node("Shooter")

var landed = false
var double_jump = true
var ground_jump = false
var coyotee_time = 0
var effective_fall = MAX_FALL

enum SpinTypes{
	POINT = 0,
	SPIN = 1
}

var spin_type  = SpinTypes.POINT

var spin_direction = 0

var shots = 3

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		if ground_jump:
			coyotee_time += delta
			if coyotee_time > 1:
				coyotee_time = 0
				ground_jump = false
		if velocity.y <= MAX_FALL:
			velocity.y += gravity * delta
			if velocity.y > MAX_FALL:
				velocity.y = MAX_FALL
			if not landed:
				match spin_type:
					SpinTypes.POINT:
						rotate(0.025 * PI * spin_direction)
					SpinTypes.SPIN:
						rotate(0.025 * PI * spin_direction)
						
		
	if is_on_floor():
		
		ground_jump = true
		double_jump = true
		landed = true
		rotation = 0
		
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			
			if direction == velocity.sign().x:
				if abs(velocity.x) < SPEED:
					velocity.x += direction * SPEED * delta
				else:
					velocity.x = TOPSPEED * velocity.sign().x
			else:
				velocity.x += direction * TURNINGSPEED * delta
				sprite.flip(direction)
				shooter.flip(direction)
			
			if abs(velocity.x) < MINSPEED:
				velocity.x = 0
				spin_direction = 0
			
			
		else:
			velocity.x -= velocity.sign().x * SLOWINGSPEED * delta
			
			if abs(velocity.x) < MINSPEED:
				velocity.x = 0
				spin_direction = 0
	
	else:
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction != 0 and direction != velocity.sign().x:
			velocity.x -= velocity.sign().x * SPEED * 0.5 * delta
			
		if abs(velocity.x) < MINSPEED:
				velocity.x = 0

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		if ground_jump:
			velocity.y = JUMP_VELOCITY
			ground_jump = false
			landed = false
			spin_direction = velocity.sign().x
		elif double_jump:
			velocity.y = DJUMP_VELOCITY
			landed = false
			double_jump = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if position.y > 1000:
		position.x = 30
		position.y = 30

	move_and_slide()
