extends "res://Scripts/Interactables/Tables/BaseTable.gd"

# Overrides base script function to make combinations from the elements of the table.
func activate_table(player):
	
	# Gets a combination from the elements of the table and gives it to the player.
	var combination = alchemy_controller.combine(elements)
	player.set_element_hold(combination)
	
	# Calls the function on the parent script.
	.activate_table(player)
