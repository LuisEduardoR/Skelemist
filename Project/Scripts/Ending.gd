extends Node

func _on_Timer_sprite_timeout():
	$char_sprite.hide()
	$Timer_black.start()
	
func _on_Timer_black_timeout():
	get_tree().change_scene("res://Scenes/Menu.tscn")
