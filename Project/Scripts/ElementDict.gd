extends Node2D

export var element_textures = [] # Stores the textures for the elements: position 0 equals texture for element id 0.
export var element_2_combinations = [] # Stores the combinations of 2 elements: 0 and 1 are the input element ids.
									   # 2 is the output element id.
export var element_4_combinations = [] # Stores the combinations of 4 elements: 0 through 3 are the input element ids.
									   # 4 is the output element id.
export var element_transmutations = [] # Stores the transmutations of elements: 0 and 1 are the input element ids.
									   # 2 is the output element id.
export var element_derivatives = [] # Stores the derivatives of the elements: 0 is the input element, 1 is the output element.

# Returns a texture for an element by id. 
func get_element_texture(id):
	
	# Prints and gives an error.
	if id < 0:
		print_debug("Warning!: Valid element ids must NOT be negative!")
	
	return element_textures[id]

# Returns the result of a combination of elements of ids e1 and e2.
func combine_2(e1, e2):
	
	# Error checking.
	if e1 == -1 or e2 == -1:
		print_debug("Warning!: Combination was called with at least one null (-1) element!")
		return -1
	
	# If elements are equal returns the element.
	if e1 == e2:
		return e1
		
	# Goes through the combinations.
	for combination in element_2_combinations:
		
		# Check if the combination exists.
		if (e1 == combination[0] and e2 == combination[1]) or (e1 == combination[1] and e2 == combination[0]):
			return combination[2] # If it does, returns the output element.
	
	return 0 # If no combination exists returns 0 (salt)
	
# Returns the result of a combination of elements of ids e1 and e2.
func combine_4(e1, e2, e3, e4):
	
	# Error checking.
	if e1 == -1 or e2 == -1 or e3 == -1 or e4 == -1:
		print_debug("Warning!: Combination was called with at least one null (-1) element!")
		return -1
		
	# Goes through the combinations.
	for combination in element_4_combinations:
		
		var correct_e1 = false
		var correct_e2 = false
		var correct_e3 = false
		var correct_e4 = false
		
		for i in range(4):
			if combination[i] == e1:
				correct_e1 = true
		for i in range(4):
			if combination[i] == e2:
				correct_e2 = true
		for i in range(4):
			if combination[i] == e3:
				correct_e3 = true
		for i in range(4):
			if combination[i] == e4:
				correct_e4 = true
				
		# Check if the combination exists.
		if correct_e1 and correct_e2 and correct_e3 and correct_e4:
			return combination[4] # If it does, returns the output element.
	
	return 0 # If no combination exists returns 0 (salt)
	
# Returns the result of a transmutation of elements of ids e1 and e2.
func transmute(e1, e2):
	
	# Error checking.
	if e1 == -1 or e2 == -1:
		print_debug("Warning!: Transmutation was called with at least one null (-1) element!")
		return -1
		
	# Goes through the combinations.
	for transmutation in element_transmutations:
		
		# Check if the combination exists.
		if (e1 == transmutation[0] and e2 == transmutation[1]) or (e1 == transmutation[1] and e2 == transmutation[0]):
			return transmutation[2] # If it does, returns the output element.
	
	return 0 # If no combination exists returns 0 (salt)
	
# Returns the result of the derivation of the element with the passed id.
func derivate(id):
	
	# Error checking.
	if id == -1:
		print_debug("Warning!: derivation was called with a null (-1) element!")
		return -1
		
	# Goes through the derivatives.
	for derivative in element_derivatives:

		# Check if the combination exists.
		if id == derivative[0]:
			return derivative[1]
			
	return 0 # If no derivative exists returns 0 (salt)