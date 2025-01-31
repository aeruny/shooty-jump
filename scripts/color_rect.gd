extends CanvasLayer

signal transitioned


func transition():
	$AnimationPlayer.play("fade_to_black")
	
func transition2():
	$AnimationPlayer.play("fade_to_normal")
