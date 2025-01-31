extends Node2D

@onready var animation_player: AnimationPlayer = $"StaticBody2D/AnimationPlayer"

# Called when the node enters the scene tree for the first time.
func play_anim(animation) -> void:
	animation_player.play(animation)

func play_sound():
	$AudioStreamPlayer2D.play()
