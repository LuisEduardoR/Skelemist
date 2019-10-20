extends "res://Scripts/Tables/4SlotTable.gd"

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
	elif element_2 == -1:
		
		element_2 = element_id
		
		# Updates graphics.
		$element_2.set_texture(element_dict.get_element_texture(element_2))
		$element_2.show()
		# Empties player's hands.
		return -1
		
	# Puts the element on the second slot.
	elif element_3 == -1:
		
		element_3 = element_id
		
		# Updates graphics.
		$element_3.set_texture(element_dict.get_element_texture(element_3))
		$element_3.show()
		# Empties player's hands.
		return -1
	
	# Puts the element on the fourth slot.
	else:
		
		element_4 = element_id
		
		# Verifies the result of the combination.
		var fusion = element_dict.combine_4(element_1, element_2, element_3, element_4)
		
		# Resets the table.	
		element_1 = -1
		element_2 = -1
		element_3 = -1
		element_4 = -1
		
		$element_1.hide()
		$element_2.hide()
		$element_3.hide()
		$element_4.hide()
		
		# Returns the resultant element.
		return fusion