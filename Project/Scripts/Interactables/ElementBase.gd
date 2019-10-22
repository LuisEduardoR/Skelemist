extends "res://Scripts/Interactables/InteractableBase.gd"

export var element_id = "salt" # Id of the element to be spawned by this base.
var alchemy_controller # Stores a reference to the alchemy controller.
var player # Stores the player.

var default_element_sprite_pos # Stored to be used for the animation.
# Used to configure the element floating animation.
export var anim_amplitude = 1.2
export var anim_period = 100
var anim_rand_offset # Adds a random offset to animations. 

func _ready():
	
	# Gets the alchemy controller, if there is more than one in the scene the first on the array will be used.
	alchemy_controller = get_tree().get_nodes_in_group("AlchemyController")[0]
	
	# Gets the default position for the element.
	default_element_sprite_pos = $element_base/element.position
	
	$element_base/element.set_texture(alchemy_controller.get_element_data(element_id).texture)
		
	# Gets the random number for the animations.
	anim_rand_offset = randi()

func _process(delta):

	# Animates the element sprite.
	$element_base/element.position = default_element_sprite_pos + Vector2(0, anim_amplitude * sin(anim_rand_offset + OS.get_ticks_msec() / anim_period))
	
# Verifies if interaction e can be had.
func is_e_avaliable(player):
	return (allow_interaction_e and player.current_element_id != element_id)
	
# Gives the element to the player.
func interact_e(player):
	player.set_element_hold(element_id)