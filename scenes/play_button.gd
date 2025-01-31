extends TextureButton

var next_scene = preload("res://scenes/start_cutscene.tscn")

func _on_pressed() -> void:
	get_tree().change_scene_to_packed(next_scene)
