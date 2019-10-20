extends KinematicBody2D

enum GAME_STATE{
  	play,
  	book,
	win
}

var current_state

export var velocity = 320
export var interact_range = 80

export var win_element_id = 16

var element_dict # Stores a reference to the element dictionary.

# Used to configure the element floating animation.
export var element_anim_amplitude = 1.2
export var element_anim_period = 100
var anim_rand_offset # Adds a random offset to animations. 
var default_element_sprite_pos # Stored to be used for the animation.

export var player_sprites = [] # Array with the player sprites for animation.

var current_element_id = -1

func _ready():
	
	# Sets the default game state.
	current_state = GAME_STATE.play
	
	# Gets the element dict.
	element_dict = get_node("/root/Node2D/ElementDict")
	
	# Gets the defailt position for the hold element.
	default_element_sprite_pos = $icons/hold_element.position
	
	# Gets the random number for the animations.
	anim_rand_offset = randi()

func _process(delta):
	
	# Checks for the win state.
	if current_element_id == win_element_id:
		current_state = GAME_STATE.win
	
	process_movement(delta)
	process_interaction()
		
	# Animates the element sprite.
	$icons/hold_element.position = default_element_sprite_pos + Vector2(0, element_anim_amplitude * sin(anim_rand_offset + OS.get_ticks_msec() / element_anim_period))
	
# Handles player movementation.
func process_movement(delta):
	
	# Doesn't move if reading the book.
	if current_state == GAME_STATE.book:
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
	
		if current_element_id != -1:
			$icons/drop.show()
		else:
			$icons/drop.hide()
			
		# Discards an element that the player is currently holding.
		if Input.is_action_just_pressed("ui_release"):
			$icons/hold_element.hide()
			$icons/drop.hide()
			current_element_id = -1
		
		var interact = check_book() # Stores if the Player can interact with the book.
		
		# If no other interaction is avalible until now, checks for element bases.
		if not interact:
			interact = check_element_bases() # Stores if the Player can interact with any element bases.
		
		# If no other interaction is avalible, checks for tables.
		if not interact:
			interact = check_tables() # Stores if the Player can interact with any tables.
	
	# If in the book state, interacts with the book.
	elif current_state == GAME_STATE.book:
		
		if Input.is_action_just_pressed("ui_down"):
			$instructions/page.hide()
			current_state = GAME_STATE.play
		elif Input.is_action_just_pressed("ui_right"):
			$instructions.next_page()
		elif Input.is_action_just_pressed("ui_left"):
			$instructions.prev_page()
	
	# If in the win condition, disallows other interactions than drinking the potion.
	elif current_state == GAME_STATE.win:
		
		$icons/drop.hide()
		$icons/pick.hide()
		$icons/put.hide()
		$icons/trash.hide()
		
		# Gives the player the final decision based on distance from the loved one object.
		var love = get_closest_by_group("Love", 1) # Remember to only allow 1 object in the Love group.
		if love != null and global_position.distance_to(love.global_position) < interact_range:
			
			# Show the decision to give the potion to the loved one.
			$icons/live_self.hide()
			$icons/live_love.show()
			
			# Give the potion.
			if Input.is_action_just_pressed("ui_interact"):
				get_tree().change_scene("res://Scenes/Endings/LoveEnd.tscn")
			
		else:
			
			# Show the decision to drink the potion yourself.
			$icons/live_self.show()
			$icons/live_love.hide()
			
			# Drink the potion.
			if Input.is_action_just_pressed("ui_interact"):
				get_tree().change_scene("res://Scenes/Endings/SelfEnd.tscn")

func check_book():
	
	# Checks for all element bases and gets the one closest within a certain range. 
	var target_book = get_closest_by_group("Book", 1)
	
	# Updates icons.
	if target_book != null:
		$icons/pick.hide()
		$icons/drop.hide()
		$icons/book.show()
	else:
		if current_element_id != -1:
			$icons/drop.show()
		$icons/book.hide()
		
	# Opens the book.
	if target_book != null and Input.is_action_just_pressed("ui_interact"):
		current_state = GAME_STATE.book
		$instructions/page.show()

# Checks for element base interaction.
func check_element_bases():
	
	# Checks for all element bases and gets the one closest within a certain range. 
	var target_base = get_closest_by_group("Bases", 1)
			
	# Updates icons.
	if target_base != null and target_base.element_id != current_element_id:
		$icons/pick.show()
		$icons/drop.hide()
	else:
		$icons/pick.hide()
			
	# Gets an element from the closest base if avaliable.
	if target_base != null and Input.is_action_just_pressed("ui_interact"):
				
		current_element_id = target_base.element_id
			
		$icons/hold_element.show()
		$icons/hold_element.set_texture(element_dict.element_textures[current_element_id])
		
	# Returns if an interaction can occur.
	if target_base == null:
		return false
	else:
		return true
		
# Checks for table interaction.
func check_tables():
	
	# Verifies if there is a table to interact with.
	var target_table = get_closest_by_group("Tables", 1.2)
			
	# Updates icons.
	# - Put/drop
	if target_table != null and current_element_id != -1:
		$icons/put.show()
		$icons/drop.hide()
	else:
		$icons/put.hide()
	
	# - Trash
	if target_table != null and not target_table.empty():
		$icons/trash.show()
	else:
		$icons/trash.hide()
	
	# Puts an element at the closest table if avaliable.
	if target_table != null and current_element_id != -1 and Input.is_action_just_pressed("ui_interact"):
		
		# Puts an element at the table.
		current_element_id = target_table.put_element(current_element_id)
		
		# Updates the element at hand.
		if current_element_id != -1:
			$icons/hold_element.set_texture(element_dict.get_element_texture(current_element_id))
		else:
			$icons/hold_element.hide()
			
	# Throws away elements from a table.
	elif target_table != null and not target_table.empty() and Input.is_action_just_pressed("ui_trash"):
		target_table.trash()
		
	# Returns if an interaction can occur.
	if target_table == null:
		return false
	else:
		return true

# Gets the closest element within a certain group.
func get_closest_by_group(group, distance_multiplier):
	
	# Gets all element tables
	var group_objs = get_tree().get_nodes_in_group(group)
	
	# Checks for all element bases and gets the one closest within a certain range.
	var closest = null
	var closest_distance = INF
	for g_obj in group_objs:
		var distance = global_position.distance_to(g_obj.global_position)
		if distance < distance_multiplier * interact_range and closest_distance > distance:
			closest = g_obj
			
	return closest