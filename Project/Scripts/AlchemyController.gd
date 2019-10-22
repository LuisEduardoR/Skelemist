extends Node2D

var element_data = {} # Contains the element's data objects.
var combination_recipes = [] # Contains the combination of two elements recipes.

func _ready():
	load_elements()
	load_combinations()
	
# Load elements from a folder.
func load_elements():

	# Clears the array.
	element_data.clear()

	print_debug("Loading element combination recipes from res://Elements/...")

	# Open the directory.
	var dir = Directory.new()
	dir.open("res://Elements")
	dir.list_dir_begin(true)
	
	# Loads resources.
	var resource = dir.get_next()
	while resource != "":
		
		var element = load("res://Elements/" + resource)
		element_data[element.id] = element
		resource = dir.get_next()
		
	print_debug("Done! " + str(element_data.size()) + " resources loaded!")
	
# Load combinations from a folder.
func load_combinations():

	# Clears the array.
	combination_recipes.clear()

	print_debug("Loading element combination recipes from res://Combinations/...")

	# Open the directory.
	var dir = Directory.new()
	dir.open("res://Combinations")
	dir.list_dir_begin(true)
	
	# Loads resources.
	var resource = dir.get_next()
	while resource != "":
	    combination_recipes.append(load("res://Combinations/" + resource))
	    resource = dir.get_next()
		
	print_debug("Done! " + str(combination_recipes.size()) + " resources loaded!")

# Returns a element data by id. 
func get_element_data(id):

	if element_data.has(id):
		return element_data[id]

	return null

# Returns the result of a combination of elements of ids e1 and e2.
func combine(elements):
	
	# Error checking.
	for element in elements:
		if element == "none":
			print_debug("Warning!: combine was called with at least one none element!")
			return
	
	# If all elements are equal returns the same element.
	for i in range(elements.size()):
		if i == elements.size() - 1:
			return elements[i]
		else:
			if elements[i] != elements[i + 1]:
				break
	
	# Goes through the recipes.
	for combination in combination_recipes:
		
		# If the number of ingredients in the combination is different from the number of ingredients used the combinations are different.
		if combination.ingredient_ids.size() != elements.size():
			continue
		
		# Stores how many elements have matched.
		var matches = 0
		
		# Stores what elements have been used.
		var used_elements = []
		for i in range(combination.ingredient_ids.size()):
			used_elements.append(false)
			
		# Checks for each element if it matches any element in the combination, also marks the element as used.
		for i in range(combination.ingredient_ids.size()):
			for j in range(elements.size()):
				if not used_elements[j] and combination.ingredient_ids[i] == elements[j]:
					matches += 1
					used_elements[j] = true
					break
		
		# Check if the combination exists.
		if matches == combination.ingredient_ids.size():
			return combination.result_id # If it does, returns the output element.
	
	return "salt" # If no combination exists returns salt.