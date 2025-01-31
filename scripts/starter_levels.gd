extends Node2D

var faded = false
var upgrade_complete = false
@onready var player = preload("res://scenes/player.tscn")
var checkpoint: Vector2 
var checkpoint_cam
var next_scene = preload("res://scenes/main_menu.tscn")

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
	$Player.position = Vector2(377, 24)
	checkpoint_cam = 1
	$Camera2D.position = Vector2(95, -101)
	$"/root/Music".play()
	$Player.control = false
	$Cutscenes.play("start_cutscene")
	checkpoint = Vector2(377, 24) # beginning of game
	

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
	if $Player.position >= Vector2(1070, 0) && $Player.position < Vector2(1933, 0): # top of pipes
		checkpoint = Vector2(1070, -823)
		checkpoint_cam = 5
	if $Player.position >= Vector2(1933, 0) && $Player.position < Vector2(2566, 0): # entered the vents
		checkpoint = Vector2(1933, -729)
		checkpoint_cam = 7
	if $Player.position >= Vector2(2566, 0) && $Player.position < Vector2(4490, 0): # end of vents
		checkpoint = Vector2(2568, -1000)
		checkpoint_cam = 8
	if $Player.position >= Vector2(4490, 0) && $Player.position < Vector2(5130, 0): # box factory
		checkpoint = Vector2(4493, -1021)
		checkpoint_cam = 11
	if $Player.position >= Vector2(5130, 0) && $Player.position < Vector2(5722, 0): # box factory 2
		checkpoint = Vector2(5132, -1181)
		checkpoint_cam = 13
	if $Player.position >= Vector2(5722, 0) && $Player.position < Vector2(6260, 0): # molten metal falls 1
		checkpoint = Vector2(5768, -709)
		checkpoint_cam = 14
	if $Player.position >= Vector2(6260, 0) && $Player.position < Vector2(6900, 0): # molten metal falls 2
		checkpoint = Vector2(6267, -837)
		checkpoint_cam = 15
	if $Player.position >= Vector2(6900, 0) && $Player.position < Vector2(7568, 0): # molten metal falls 3
		checkpoint = Vector2(6945, -821)
		checkpoint_cam = 16
	if $Player.position >= Vector2(7568, 0):
		checkpoint = Vector2(7568, -725)
		checkpoint_cam = 17
	if $Player.position.x >= 7900 && $Player.position.y <= -950 && faded == false:
		$TransitionScreen.transition()
		faded = true
		$Player.control = false
		$EndTimer.start()
		

func _on_timer_timeout() -> void:
	$Cutscenes.play("end_cutscene")
	

func end() -> void:
	get_tree().change_scene_to_packed(next_scene)
