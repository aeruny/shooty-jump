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
			camera_position = Vector2(95, -101)
			if player.position.x > position.x + CAMERA_WIDTH/2:
				position = Vector2(720, -309)
				current_scene = 2
		2: # upgrade conveyor
			camera_position = Vector2(720, -309)
			if player.position.x < position.x - CAMERA_WIDTH/2:
				position = Vector2(95, -101)
				current_scene = 1
			if player.position.y < -428:
				position = Vector2(720, -565)
				current_scene = 3
		3: # up the pipes 1
			camera_position = Vector2(720, -565)
			if player.position.y > position.y + CAMERA_HEIGHT/2:
				position = Vector2(720, -309)
				current_scene = 2
			if player.position.y < -690:
				position = Vector2(720, -795)
				current_scene = 4
				
		4: # up the pipes 2
			camera_position = Vector2(720, -795)
			if player.position.y > position.y + CAMERA_HEIGHT/2:
				position = Vector2(720, -565)
				current_scene = 3
			if player.position.x > position.x + CAMERA_WIDTH/2:
				position = Vector2(1345, -795)
				current_scene = 5
		
		5: # along the pipes
			camera_position = Vector2(1345, -795)
			if player.position.x < position.x - CAMERA_WIDTH/2:
				position = Vector2(720, -795)
				current_scene = 4
			if player.position.x > 1435:
				position = Vector2(1613, -795)
				current_scene = 6
				
		6: # jump into vent
			camera_position = Vector2(1613, -795)
			if player.position.x < position.x - CAMERA_WIDTH/2:
				position = Vector2(1345, -795)
				current_scene = 5
			if player.position.x > position.x + CAMERA_WIDTH/2:
				position = Vector2(2241, -889)
				current_scene = 7
		7: # vents 1
			camera_position = Vector2(2241,-889)
			if player.position.x < position.x - CAMERA_WIDTH/2:
				position = Vector2(1613, -795)
				current_scene = 6
			if player.position.x > position.x + CAMERA_WIDTH/2:
				position = Vector2(2880, -982)
				current_scene = 8
		8: # vents 2
			camera_position = Vector2(2880,-982)
			if player.position.x < position.x - CAMERA_WIDTH/2:
				position = Vector2(2241, -889)
				current_scene = 6
