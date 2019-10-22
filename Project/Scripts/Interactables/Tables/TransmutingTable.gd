extends "res://Scripts/Interactables/Tables/BaseTable.gd"

# Overrides base script function to make combinations from the elements of the table.
func activate_table(player):
		
	# Gets a transmutation from the element on the table and gives it to the player.
	var ingredient = "salt"
	for element in elements:
		if element != "mercury":
			ingredient = element
			break
	
	# Verifies the result of the transmutation.
	var transmutated = alchemy_controller.get_element_data(ingredient).transmutated_id
	player.set_element_hold(transmutated)
		
	# Calls the function on the parent script.
	.activate_table(player)