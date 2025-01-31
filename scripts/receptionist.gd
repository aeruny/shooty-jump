extends StaticBody2D

const lines: Array[String] = [
	"HEY!!",
	"Why are you here?!",
	"This is the gun factory's main lobby!",
	"If you're trying to escape", 
	"I hate to break it to you but,",
	"ALL guns stay IN the factory!",
	"So don't get any funny ideas.",
	"Luckily I control the doors.",
	"Well... one door."
]

const lines2: Array[String] = [
	"WOAH! WOAH!",
	"OK I'LL OPEN THE DOOR!"
]

var warning = false
var dead = false
var done = false
var inside = false

func _ready():
	$Label.hide()

func _shot():
	if done == false:
		if DialogManager.is_dialog_active == true:
			DialogManager.is_dialog_active = false
			DialogManager.text_box.queue_free()
		$"../Cutscenes".play("open_door")
	$AnimatedSprite2D.play("death")
	dead = true
	
func _warning():
	if DialogManager.is_dialog_active == true:
		DialogManager.is_dialog_active = false
		DialogManager.text_box.queue_free()
		DialogManager.current_line_index = 0
		$AnimatedSprite2D.play("default")
	DialogManager.start_dialog(global_position - Vector2(12,-20), lines2)
	$AnimatedSprite2D.play("talk")

func _start_dialogue():
	DialogManager.start_dialog(global_position - Vector2(12,-20), lines)
	$AnimatedSprite2D.play("talk")

func _physics_process(delta):
	if Input.is_action_just_pressed("Click") && dead == false && $"../Player".control == true:
		$Timer.start()
	if DialogManager.is_dialog_active == false && warning == true && done == false:
		$"../Cutscenes".play("open_door")
		done = true
	if Input.is_action_just_pressed("advance_dialog") && inside == true:
		$Label.hide()
	if DialogManager.is_dialog_active == false && !dead:
		$AnimatedSprite2D.play("default")

func _on_timer_timeout() -> void:
	if dead == false && warning == false:
		_warning()
		warning = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player" && !dead:
		$Label.show()
		inside = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$Label.hide()
		inside = false

func play_death():
	if dead:
		$AudioStreamPlayer2D.play()
