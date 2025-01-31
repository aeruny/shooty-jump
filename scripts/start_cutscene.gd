extends Control

var next_scene = preload("res://scenes/starter_levels.tscn")

func _ready():
	$Label.hide()

func _on_video_stream_player_finished() -> void:
	get_tree().change_scene_to_packed(next_scene)

func _unhandled_input(event: InputEvent) -> void:
	$Label.show()
	$Timer.start()
	if event.is_action_pressed("jump"):
		get_tree().change_scene_to_packed(next_scene)


func _on_timer_timeout() -> void:
	$Label.hide()
