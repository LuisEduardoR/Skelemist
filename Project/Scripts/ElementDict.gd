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
		
	# Creates an array with the elements.
	var element_array = []
	element_array.append(e1)
	element_array.append(e2)
	element_array.append(e3)
	element_array.append(e4)
		
	# Goes through the combinations.
	for combination in element_4_combinations:
		
		# Stores how many elements have matched.
		var matches = 0
		
		# Stores what elements have been used.
		var used_elements = []
		for i in range(4):
			used_elements.append(false)
		
		# Checks for each element if it matches any element in the combination, also marks the element as used.
		for i in range(4):
			for j in range(4):
				if not used_elements[j] and combination[i] == element_array[j]:
					matches += 1
					used_elements[j] = true
					break
				
		# Check if the combination exists.
		if matches == 4:
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