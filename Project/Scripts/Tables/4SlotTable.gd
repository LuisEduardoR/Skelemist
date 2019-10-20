# This class extends the base template and adds fuctionality common to tables with 4 element slots.

extends "res://Scripts/Tables/BaseTable.gd"

# Ids of the table's elements. 
var element_1 = -1
var element_2 = -1
var element_3 = -1
var element_4 = -1

# Used to configure the elements floating animation.
export var anim_amplitude = 1.2
export var anim_period = 100
var anim_rand_offset # Adds a random offset to animations. 

var default_element_1_sprite_pos # Stored to be used for the animation.
var default_element_2_sprite_pos # Stored to be used for the animation.
var default_element_3_sprite_pos # Stored to be used for the animation.
var default_element_4_sprite_pos # Stored to be used for the animation.

# Called when the node enters the scene tree for the first time. Overrides _ready function from BaseTabçe.
func _ready():
	
	._ready() # Calls parent.
	
	# Gets the random number for the animations.
	anim_rand_offset = randi()
	
	# Gets the default position for the elements.
	default_element_1_sprite_pos = $element_1.position
	default_element_2_sprite_pos = $element_2.position
	default_element_3_sprite_pos = $element_3.position
	default_element_4_sprite_pos = $element_4.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Animates the element sprite.
	$element_1.position = default_element_1_sprite_pos + Vector2(0, anim_amplitude * sin(PI + anim_rand_offset + OS.get_ticks_msec() / anim_period))
	$element_2.position = default_element_2_sprite_pos + Vector2(0, anim_amplitude * sin((PI / 2) * anim_rand_offset + OS.get_ticks_msec() / anim_period))
	$element_3.position = default_element_3_sprite_pos + Vector2(0, anim_amplitude * sin(PI + anim_rand_offset + OS.get_ticks_msec() / anim_period))
	$element_4.position = default_element_4_sprite_pos + Vector2(0, anim_amplitude * sin((3 * (PI / 2)) * anim_rand_offset + OS.get_ticks_msec() / anim_period))

# Overrides empty function from BaseTable.
func empty():
	
	# Verifies if there is an element on the table.
	if element_1 != -1 or element_2 != -1 or element_3 != -1 or element_4 != -1:
		return false
	
	return true

# Overrides trash function from BaseTable.
func trash():
	
	if empty():
		return
		
	# Resets the table.	
	element_1 = -1
	element_2 = -1
	element_3 = -1
	element_4 = -1
	
	$element_1.hide()
	$element_2.hide()
	$element_3.hide()
	$element_4.hide()