extends "res://Scripts/Tables/BaseTable.gd"

func put_element(element_id):
		
	# Error checking.
	if element_id == -1:
		print_debug("Warning! put_element was called with null element (-1)!")
		return -1
		
	# Verifies the result of the derivation.
	var derivative = element_dict.derivate(element_id)
	
	return derivative
	
# # Overrides empty function from BaseTable. Derivation table is always empty.
func empty():
	return true
	
# # Overrides trash function from BaseTable. Derivation table never has elements to trash.
func trash():
	pass