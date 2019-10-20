extends StaticBody2D

export var element_id = 2 # Id of the element to e spawned by this base.
var element_dict # Stores a reference to the element dictionary.
var player # Stores the player.

var default_element_sprite_pos # Stored to be used for the animation.
# Used to configure the element floating animation.
export var anim_amplitude = 1.2
export var anim_period = 100
var anim_rand_offset # Adds a random offset to animations. 


func _ready():
	
	# Gets the element dict.
	element_dict = get_node("/root/Node2D/ElementDict")
	# Gets the default position for the element.
	default_element_sprite_pos = $element_base/element.position
	
	# Changes the sprite to match element id.
	if element_dict != null:
		$element_base/element.set_texture(element_dict.element_textures[element_id])
		
	# Gets the random number for the animations.
	anim_rand_offset = randi()

func _process(delta):

	# Animates the element sprite.
	$element_base/element.position = default_element_sprite_pos + Vector2(0, anim_amplitude * sin(anim_rand_offset + OS.get_ticks_msec() / anim_period))
	
	# Element