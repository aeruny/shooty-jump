extends Node

var targetnumber = 0
@onready var text_box_scene = preload("res://scenes/text_box.tscn")
var normal = true
var dialog_lines: Array[String] = []
var current_line_index = 0
var time
var advance
var text_box
var text_box_position: Vector2

var is_dialog_active = false
var can_advance_line = false

func start_dialog(position: Vector2, lines: Array[String]):
	if is_dialog_active:
		return
		
	dialog_lines = lines
	text_box_position = position
	_show_text_box()
	
	is_dialog_active = true
	
func _show_text_box():
	text_box = text_box_scene.instantiate()
	text_box.finished_displaying.connect(_on_text_box_finished_displaying)
	get_tree().root.add_child(text_box)
	text_box.global_position = text_box_position
	text_box.display_text(dialog_lines[current_line_index])
	can_advance_line = false
	
func _on_text_box_finished_displaying():
	can_advance_line = true
	
func _unhandled_input(event):
	if normal == true:
		if (
			event.is_action_pressed("advance_dialog") &&
			is_dialog_active &&
			can_advance_line &&
			($"/root/StarterLevels/Player".position.x - text_box_position.x) < 50 && # so you have to be close
			($"/root/StarterLevels/Player".position.x - text_box_position.x) > -50
		):
			text_box.queue_free()
			
			current_line_index += 1
			if current_line_index >= dialog_lines.size():
				is_dialog_active = false
				current_line_index = 0
				return
			
			_show_text_box()
			
func _process(delta: float) -> void:
	if normal == false:
		if  (  
			$"/root/StarterLevels/Wizard".talk == true &&
			is_dialog_active &&
			can_advance_line
		):
			text_box.queue_free()
			
			current_line_index += 1
			if current_line_index >= dialog_lines.size():
				is_dialog_active = false
				current_line_index = 0
				return
			
			_show_text_box()
			$"/root/StarterLevels/Wizard". talk = false
			
