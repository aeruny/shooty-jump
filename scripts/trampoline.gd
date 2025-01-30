extends AnimatableBody2D

var send_player_up = false
var initial_height = 0
var player = null
var additional_rotation = 0

@export var trampoline_jump_height = -500
# trampoline type: 0 - replenish ammo, 1 - do not replenish ammo
@export var trampoline_type = 0
@export var texture: Texture2D
@onready var sprite_2d: Sprite2D = $Sprite2D

const AIR_ASSISTANCE = 10
const SPEED = -400

func _ready() -> void:
	trampoline_type = clampi(trampoline_type, 0, 3)
	match trampoline_type:
		0:
			#sprite_2d.texture =  load('res://assets/sprites/platforms.png')
			#sprite_2d.region_rect = Rect2(16, 48, 32, 9)
			pass
		1:
			#sprite_2d.texture =  load('res://assets/sprites/platforms.png')
			#sprite_2d.region_rect = Rect2(16, 32, 32, 9)
			additional_rotation = deg_to_rad(50)
		2:
			pass
		3:
			additional_rotation = deg_to_rad(-45)
			
func _physics_process(delta):
	# Old code to send player up
	#if send_player_up == true:
	#	player.velocity.y = SPEED * delta
	#	if player.position.y <= initial_height - trampoline_jump_height:
	#		send_player_up = false
	#		initial_height = 0
			
	#if send_player_up == true and (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right") and !Input.is_action_pressed("jump")):
	#	var direction = Input.get_axis("move_left", "move_right")
	#	player.velocity.x = player.velocity.x * direction * AIR_ASSISTANCE
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player = body
		player.trampoline_touch = true
		player.trampoline_type = 0
		player.velocity = Vector2(player.velocity.x, trampoline_jump_height).rotated(rotation+additional_rotation)
		$AnimatedSprite2D.play("bounce")
		$BounceSound.play()
		#initial_height = player.position.y
		#send_player_up = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		body.trampoline_touch = false
