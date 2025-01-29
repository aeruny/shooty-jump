extends Node2D

var upgrade_complete = false
@onready var player = preload("res://scenes/player.tscn")
var checkpoint: Vector2 
var checkpoint_cam

func respawn() -> void:
	$Player.velocity = Vector2(0,0)
	$Player.global_position = checkpoint
	$Player.rotation = 0
	$Player.control = true
	$Camera2D.current_scene = checkpoint_cam
	$RespawnTimer.start()
		
func _on_respawn_timer_timeout() -> void:
	$Camera2D.position = $Camera2D.camera_position # only way this will work
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player.control = false
	$Cutscenes.play("start_cutscene")
	checkpoint = Vector2(377, 24) # beginning of game
	checkpoint_cam = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Player.position >= Vector2(580,0) && upgrade_complete == false:
		$ConveyorBelt.speed = Vector2(0,0)
		$Player.control = false
		$Cutscenes.play("upgrade_animation")
		$Player.acquired_double_jump = true
		upgrade_complete = true
		$ConveyorBelt.speed = Vector2(0.75,0)
		checkpoint = Vector2(467, -153) # got the upgrade
		checkpoint_cam = 2
	if $Player.position >= Vector2(1070, 0): # top of pipes
		checkpoint = Vector2(1070, -823)
		checkpoint_cam = 5
	if $Player.position >= Vector2(1933, 0): # entered the vents
		checkpoint = Vector2(1933, -729)
		checkpoint_cam = 7
	if $Player.position >= Vector2(2566, 0):
		checkpoint = Vector2(2568, -1000)
		checkpoint_cam = 8
