extends Control

var bullet_count

@onready var grid_container: GridContainer = $GridContainer
@onready var player: CharacterBody2D = $"../Player"

var disp_offset = Vector2(-20,0)

const BULLET_INDICATOR = preload("res://scenes/bullet_indicator.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.connect("bullet_update", update_bullets_display, 1)
	for i in range(3):
		add_bullet()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = player.position - disp_offset


func update_bullets_display(amount):
	if amount > 0:
		for i in range(amount):
			add_bullet()
	else:
		for i in range(-amount):
			delete_bullet()
			
	if disp_offset.x > 4:
		disp_offset.x = 4

func add_bullet():
	var bullet = BULLET_INDICATOR.instantiate()
	grid_container.add_child(bullet)
	disp_offset.x += 4


func delete_bullet():
	var bullet = grid_container.get_child(0,false)
	if bullet:
		bullet.queue_free()
		disp_offset.x -= 4
