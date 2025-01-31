extends Camera2D

@onready var player: CharacterBody2D = $"../Player"

var current_scene = 1
var camera_position

const CAMERA_WIDTH = 640
const CAMERA_HEIGHT = 360

var scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match current_scene:
		1: # lobby
			print("bruh")
			camera_position = Vector2(95, -101)
			if player.position.x > position.x + CAMERA_WIDTH/2:
				position = Vector2(720, -309)
				current_scene = 2
		2: # upgrade conveyor
			print("loser")
			camera_position = Vector2(720, -309)
			if player.position.x < position.x - CAMERA_WIDTH/2:
				position = Vector2(95, -101)
				current_scene = 1
			if player.position.y < -428:
				position = Vector2(720, -565)
				current_scene = 3
