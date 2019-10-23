extends "res://Scripts/Interactables/InteractableBase.gd"

var alchemy_controller # Stores a reference to the alchemy controller.

export var fillable_element_ids = [ "earth", "mud"]

func _ready():
	
	# Gets the alchemy controller, if there is more than one in the scene the first on the array will be used.
	alchemy_controller = get_tree().get_nodes_in_group("AlchemyController")[0]
	
# Verifies if interaction e can be had.
func is_e_avaliable(player):
	
	# Checks if the player has a element that can fill the epty pit.
	for element in fillable_element_ids:
		
		if element == player.current_element_id:
			return allow_interaction_e
			
	return false
	
# Overrides put_element function from BaseTable.
func interact_e(player):
	
	# Gets the element currently hold by the player.
	var element_id = player.current_element_id
	
	# Checks if the player has a element that can fill the empty pit.
	for i in range(fillable_element_ids.size()):
		
		# Fills the pit with the correct element.
		if fillable_element_ids[i] == player.current_element_id:
			
			# Sets the texture.
			$graphics.play(fillable_element_ids[i]);
			$graphics.show()
			
			# Removes the collider.
			$StaticBody2D/CollisionShape2D.set_disabled(true)
			allow_interaction_e = false
		
	# Empties player's hands.
	player.set_element_hold("none")