# This class is a base template for creating a table that the player can use elements to interact
extends "res://Scripts/Interactables/InteractableBase.gd"

# Gets the alchemy controller, if there is more than one in the scene the first on the array will be used.
var alchemy_controller

# Number of elements this table accepts.
export var number_of_elements = 1
# Ids of the elements in the table. 
var elements = []
# Stores the slot on the table that should be used next.
var slot_to_use

# Used to configure the elements floating animation.
export var anim_amplitude = 1.2
export var anim_period = 100
var anim_rand_offset # Adds a random offset to animations. 
var default_element_sprite_pos = [] # Stored to be used for the animation.

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Gets the element dict.
	alchemy_controller = get_tree().get_nodes_in_group("AlchemyController")[0]
	
	# Gets the random number for the animations.
	anim_rand_offset = randi()
	
	# Gets the default position for the elements.
	elements.resize(number_of_elements)
	for i in range(number_of_elements):
		elements[i] = "none"
		default_element_sprite_pos.append(get_node("element_" + str(i)).position)
	
	# Resets the table at start.
	reset_table()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Animates the element sprite.
	for i in range(elements.size()):
		var element_sprite = get_node("element_" + str(i))
		element_sprite.position = default_element_sprite_pos[i] + Vector2(0, anim_amplitude * sin(i * (2 * PI / number_of_elements) + anim_rand_offset + OS.get_ticks_msec() / anim_period))

# Checks if an element can be put at the table.
func is_e_avaliable(player):
	return (allow_interaction_e and player.current_element_id != "none")

	
# Checks if it's possible to trash the elements of the table.
func is_t_avaliable(player):
	
	# Verifies if the table is not empty.
	for element in elements:
		if element != "none":
			return allow_interaction_t
	
	return false

# Trashs the elements of the table.
func interact_t(player):
	reset_table()

# Overrides put_element function from BaseTable.
func interact_e(player):
	
	# Gets the element currently hold by the player.
	var element_id = player.current_element_id
	
	# Puts an element on a table slot.
	#  - Puts an element on the table when it's not the last slot.
	if slot_to_use < number_of_elements - 1:
		
		elements[slot_to_use] = element_id
	
		# Updates graphics.
		var element_sprite = get_node("element_" + str(slot_to_use))
		element_sprite.set_texture(alchemy_controller.get_element_data(elements[slot_to_use]).texture)
		element_sprite.show()
		
		# Empties player's hands.
		player.set_element_hold("none")
		
		# Sets the next slot to be used.
		slot_to_use += 1
		
	# - Puts an element on the last slot and activates the table..
	else:
		elements[slot_to_use] = element_id
		activate_table(player)

# Used to do something when the table has been filled with all the elements.
func activate_table(player):
	reset_table() # Rests the table after it has been activated.

# Resets the table, removing all elements.
func reset_table():
	
	# Resets the slot to be used.
	slot_to_use = 0
	
	# Resets the elements and graphics.
	for i in range(number_of_elements):
		
		elements[i] = "none"
		var element_sprite = get_node("element_" + str(i))
		element_sprite.hide()