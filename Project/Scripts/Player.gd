extends KinematicBody2D

# Describes the game current state.
enum GAME_STATE {
  	play,
  	book,
	win,
	pause
}
var current_state
var previous_state

export var velocity = 240

# Element that has to be made for the game to be won.
export var win_element_id = "life"

# Textues used for player specific interactions.
export(Texture) var drop_icon
export(Texture) var self_icon
export(Texture) var love_icon

# Stores a reference to the alchemy controller.
var alchemy_controller
var current_element_id

# Used to configure the element floating animation.
export var element_anim_amplitude = 1.2
export var element_anim_period = 100
var anim_rand_offset # Adds a random offset to animations. 
var default_element_sprite_pos # Stored to be used for the animation.

func _ready():
	
	# Sets the game default state.
	set_state(GAME_STATE.play)
	
	# Gets the alchemy controller, if there is more than one in the scene the first on the array will be used.
	alchemy_controller = get_tree().get_nodes_in_group("AlchemyController")[0]
	
	# Starts the game with no element.
	set_element_hold("none")
	
	# Gets the defailt position for the hold element.
	default_element_sprite_pos = $icons/hold_element.position
	
	# Gets the random number for the animations.
	anim_rand_offset = randi()
	
	# Allows this script to run when paused.
	pause_mode = Node.PAUSE_MODE_PROCESS
	$Pause.pause_mode = Node.PAUSE_MODE_PROCESS

func _process(delta):
	
	# Checks for the win state.
	if current_element_id == win_element_id:
		set_state(GAME_STATE.win)
	
	process_movement(delta)
	process_interaction()
		
	# Animates the element sprite.
	$icons/hold_element.position = default_element_sprite_pos + Vector2(0, element_anim_amplitude * sin(anim_rand_offset + OS.get_ticks_msec() / element_anim_period))
	
# Handles player movementation.
func process_movement(delta):
	
	# Doesn't move if reading the book.
	if current_state == GAME_STATE.book or current_state == GAME_STATE.pause:
		return
	
	# Receives movement input.
	var input_dir = Vector2(0, 0)
	var playing_anim = false
	if Input.is_action_pressed("ui_down"):
		input_dir.y += 1
		if not playing_anim:
			playing_anim = true
			$graphics.play("down");
	if Input.is_action_pressed("ui_up"):
		input_dir.y -= 1
		if not playing_anim:
			playing_anim = true
			$graphics.play("up");
	if Input.is_action_pressed("ui_left"):
		input_dir.x -= 1
		if not playing_anim:
			playing_anim = true
			$graphics.play("left");
	if Input.is_action_pressed("ui_right"):
		input_dir.x += 1
		if not playing_anim:
			playing_anim = true
			$graphics.play("right");
	
	# Stops player animation if no movement input is provided.
	if sqrt(input_dir.x*input_dir.x + input_dir.y*input_dir.y) == 0:
		$graphics.play("idle")
	
	# Moves the Player.
	var move_vet = input_dir.normalized() * velocity * delta
	if not test_move(transform , move_vet, true): # Verifies if the player won't collide.
		position += move_vet
	else: # Stop player animation if no movement is possible.
		$graphics.play("idle")
	
# Handles player interaction with scenery.
func process_interaction():
	
	# If in the play state look for interactions normally.
	if current_state == GAME_STATE.play:
		
		# Pauses the game showing the menu.
		if Input.is_action_just_pressed("ui_cancel"):
			set_state(GAME_STATE.pause)
			return
		
		# Gets the closest interactable item.
		var interactable = get_closest_by_group("Interactable", 1)
		
		# If an interactable is avaliable, checks for possible interactions.
		if interactable != null:
			
			# Checks for interaction e.
			if interactable.is_e_avaliable(self):
				$icons/interact_e.set_texture(interactable.interaction_icon_e)
				$icons/interact_e.show()
				if Input.is_action_just_pressed("ui_interact_e"):
					interactable.interact_e(self)
			else:
				$icons/interact_e.hide()
			
			# Checks for interaction r.
			if interactable.is_r_avaliable(self):
				$icons/interact_r.set_texture(interactable.interaction_icon_r)
				$icons/interact_r.show()
				if Input.is_action_just_pressed("ui_interact_r"):
					$icons/interact_e.set_texture(interactable.interaction_icon_e)
					interactable.interact_r(self)
			else:
				$icons/interact_r.hide()
					
			# Checks for interaction t.
			if interactable.is_t_avaliable(self):
				$icons/interact_t.set_texture(interactable.interaction_icon_t)
				$icons/interact_t.show()
				if Input.is_action_just_pressed("ui_interact_t"):
					interactable.interact_t(self)
			else:
				$icons/interact_t.hide()
				
		# If no interaction can be had, hide the interaction icons.
		else:
			$icons/interact_e.hide()
			$icons/interact_r.hide()
			$icons/interact_t.hide()
		
		# If carrying an element and no interaction can be had using ui_interact_r, gives the option to drop the element.
		if current_element_id != "none":
			
			if (interactable == null or not interactable.allow_interaction_r):
				$icons/interact_r.set_texture(drop_icon)
				$icons/interact_r.show()
				if Input.is_action_just_pressed("ui_interact_r"):
					$icons/interact_r.hide()
					set_element_hold("none")
					
		elif (interactable != null and not interactable.allow_interaction_r):
			$icons/interact_r.hide()
	
	# If in the book state stops the player and leaves interaction to the book.
	elif current_state == GAME_STATE.book:
		
		# Hide sthe interaction icons.
		$icons/interact_e.hide()
		$icons/interact_r.hide()
		$icons/interact_t.hide()
	
	# If in the win condition, disallows other interactions than drinking the potion.
	elif current_state == GAME_STATE.win:
		
		# Setups the interface.
		$icons/interact_e.set_texture(self_icon)
		$icons/interact_r.set_texture(love_icon)
		$icons/interact_t.hide()
		
		# Gets the closest interactable item (Will be either).
		var love = get_closest_by_group("Love", 1)
		
		# Checks for the interaction to give the potion.
		if love != null:
			$icons/interact_e.hide()
			$icons/interact_r.show()
			if Input.is_action_just_pressed("ui_interact_r"):
				get_tree().change_scene("res://Scenes/Endings/LoveEnd.tscn")
		# Shows the interaction to drink the potion yourself.
		else:
			$icons/interact_e.show()
			$icons/interact_r.hide()
			if Input.is_action_just_pressed("ui_interact_e"):
				get_tree().change_scene("res://Scenes/Endings/SelfEnd.tscn")
				
	# If the game is paused show the pause menu and disallows interaction.
	elif current_state == GAME_STATE.pause:
		
		# Hide sthe interaction icons.
		$icons/interact_e.hide()
		$icons/interact_r.hide()
		$icons/interact_t.hide()
		
		# Unpauses the game.
		if Input.is_action_just_pressed("ui_cancel"):
			set_state(previous_state)

# Gets the closest object within a certain group.
func get_closest_by_group(group, distance_multiplier):
	
	# Gets all element tables
	var group_objs = get_tree().get_nodes_in_group(group)
	
	# Checks for all element bases and gets the one closest within a certain range.
	var closest = null
	var closest_distance = INF
	for g_obj in group_objs:
		
		# If testing for interactable objects:
		if group == "Interactable":
			# Checks if the object has at least one interaction avaliable.
			if not (g_obj.is_e_avaliable(self) or g_obj.is_r_avaliable(self) or g_obj.is_t_avaliable(self)):
				continue
		
		# Checks for the distance.
		var distance = global_position.distance_to(g_obj.global_position)
		if distance < distance_multiplier * g_obj.interaction_range and closest_distance > distance:
			closest = g_obj
			
	return closest

# Changes the element the player is holding (use "none" for no element).
func set_element_hold(id):
	
	# Sets the current element id.
	current_element_id = id
	
	# Updates the element icons.
	if id == "none":
		$icons/hold_element.hide()
		return
	$icons/hold_element.set_texture(alchemy_controller.get_element_data(id).texture)
	$icons/hold_element.show()
	
# Changes the player state and saves the previous state.
func set_state(state):
	
	# Gets if the game time should be paused or not.
	if state == GAME_STATE.book or state == GAME_STATE.pause:
		get_tree().paused = true
		$graphics.pause_mode = Node.PAUSE_MODE_STOP
		
		if state == GAME_STATE.pause:
			$Pause/Container.show()
		
	else:
		get_tree().paused = false
		$graphics.pause_mode = Node.PAUSE_MODE_INHERIT
		$Pause/Container.hide()
	
	previous_state = current_state # Saves the previous state.
	current_state = state

# Unpauses the game.
func _on_ContinueButton_pressed():
	set_state(previous_state)

# Quits to the menu.
func _on_MenuButton_pressed():
	
	# Unpauses the tree and goes to the menu.
	get_tree().paused = false
	get_tree().change_scene("res://Scenes/Menu.tscn")
