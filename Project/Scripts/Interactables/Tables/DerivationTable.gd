extends "res://Scripts/Interactables/Tables/BaseTable.gd"

# Overrides base script function to make combinations from the elements of the table.
func activate_table(player):
		
	# Gets a derivation from the element on the table and gives it to the player.
	var derivative = alchemy_controller.get_element_data(elements[0]).derivative_id
	player.set_element_hold(derivative)
	
	# Calls the function on the parent script.
	.activate_table(player)