# Controls the main menu.
extends CanvasLayer

func _on_PlayButton_pressed():
	get_tree().change_scene("res://Scenes/Gameplay.tscn")

func _on_CreditsButton_pressed():
	$Container/Main.hide()
	$Container/Credits.show()

func _on_QuitButton_pressed():
	get_tree().quit()
	
func _on_BackButton_pressed():
	$Container/Main.show()
	$Container/Credits.hide()
