extends Area2D

@export var door: Node2D
@onready var timer: Timer = $Timer
var state = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("off")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if state == 0:
		state = 1
		$AnimatedSprite2D.play("on")
		door.get_child(0).get_node("AnimationPlayer").play("open")
		door.get_child(0).get_node("AnimatedSprite2D").frame = 1
		timer.start()

func _on_timer_timeout() -> void:
	timer.stop()
	state = 0
	door.get_child(0).get_node("AnimationPlayer").play("close")
	door.get_child(0).get_node("AnimatedSprite2D").frame = 0
	$AnimatedSprite2D.play("off")
	
