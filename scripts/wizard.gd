extends StaticBody2D

var talk = false

const lines: Array[String] = [
	"Well... well... well...",
	"Finally... you arrive...",
	"You may not know who I am...",
	"But I know everything about you.", 
	"There's a factory where they make humans in the sky.",
	"Go there and you will find your answers.",
	"You will encounter many challenges along your journey.",
	"I can only wish you make it safely...",
	"I bid you farewell...", 
	"Until next time..."
]

func start_dialogue():
	$Timer.start()
	$"/root/DialogManager".normal = false
	DialogManager.start_dialog(global_position - Vector2(12,-20), lines)

func play_anim(animation: String):
	$AnimatedSprite2D.play(animation)

func _on_timer_timeout() -> void:
	talk = true
