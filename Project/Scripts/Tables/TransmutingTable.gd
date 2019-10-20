extends "res://Scripts/Tables/2SlotTable.gd"

# Overrides put_element function from BaseTable.
func put_element(element_id):
	
	# Error checking.
	if element_id == -1:
		print_debug("Warning! put_element was called with null element (-1)!")
		return -1
	
	# Puts the element on the first slot.
	if element_1 == -1:
		
		element_1 = element_id
		
		# Updates graphics.
		$element_1.set_texture(element_dict.get_element_texture(element_1))
		$element_1.show()
		# Empties player's hands.
		return -1
	
	# Puts the element on the second slot.
	else:
		
		element_2 = element_id
		
		# Verifies the result of the combination.
		var fusion = element_dict.transmute(element_1, element_2)
		
		# Resets the table.	
		element_1 = -1
		element_2 = -1
		
		$element_1.hide()
		$element_2.hide()
		
		# Returns the resultant element.
		return fusion