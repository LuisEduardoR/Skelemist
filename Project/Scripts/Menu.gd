# Controls the main menu.

extends Node2D

func _on_PlayButton_pressed():
	get_tree().change_scene("res://Scenes/Gameplay.tscn")


func _on_CreditsButton_pressed():
	$Main.hide()
	$Credits.show()


func _on_QuitButton_pressed():
	get_tree().quit()
	
func _on_BackButton_pressed():
	$Main.show()
	$Credits.hide()
