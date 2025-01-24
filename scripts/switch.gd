extends Area2D

@export var door: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if $AnimatedSprite2D.frame == 0:
		$AnimatedSprite2D.frame = 1
		door.get_child(0).get_node("AnimationPlayer").play("open")
