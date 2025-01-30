extends Camera2D

@onready var player: CharacterBody2D = $"../Player"

var current_scene = 1

const CAMERA_WIDTH = 640
const CAMERA_HEIGHT = 360

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(position.x)
	
	match current_scene:
		1:
			if player.position.x < position.x - CAMERA_WIDTH/2:
				position = Vector2(position.x - CAMERA_WIDTH, position.y)
				current_scene = 3
			if player.position.x > position.x + CAMERA_WIDTH/2:
				position = Vector2(position.x + CAMERA_WIDTH, position.y)
				current_scene = 2
		
		2:
			if player.position.x < position.x - CAMERA_WIDTH/2:
				position = Vector2(position.x - CAMERA_WIDTH, position.y)
				current_scene = 1
		
		3:
			if player.position.x < position.x - CAMERA_WIDTH/2:
				position = Vector2(position.x - CAMERA_WIDTH, position.y)
				current_scene = 4
			if player.position.x > position.x + CAMERA_WIDTH/2:
				position = Vector2(position.x + CAMERA_WIDTH, position.y)
				current_scene = 1
		4:

			if player.position.x > position.x + CAMERA_WIDTH/2:
				position = Vector2(position.x + CAMERA_WIDTH, position.y)
				current_scene = 3
	
