extends "res://Scripts/Interactables/InteractableBase.gd"

# If the box is opened.
var opened

# Must be set to the number of pages.
export var pages = 0

# Current page.
var cur_page

# Stores a reference to the player.
var player

func _ready():
	
	# Initializes the book.
	opened = false
	cur_page = 0;
	
func _process(delta):
	
	# Process interaction when the book is opened.
	if opened:
		if Input.is_action_just_pressed("ui_down"):
			
			# Closes the book.
			opened = false
			
			# Hides the interface.
			$CanvasLayer/interface.hide()
			
			# Resets player state.
			player.current_state = player.GAME_STATE.play
			
		if Input.is_action_just_pressed("ui_left"): # Previous page.
			prev_page()
		if Input.is_action_just_pressed("ui_right"): # Next page.
			next_page()

# Opens the book.
func interact_e(player):
	
	opened = true
	
	# Sets the player state.
	player.current_state = player.GAME_STATE.book
	self.player = player
	
	# SHows the interface.
	$CanvasLayer/interface.show()
	

# Goes to the next page.
func next_page():
	
	if cur_page < pages:
		
		# Hides current page.W
		get_node("CanvasLayer/interface/page_" + str(cur_page)).hide()
		# Shows next page.
		cur_page += 1
		get_node("CanvasLayer/interface/page_" + str(cur_page)).show()
		
		# Update interaction icons.
		update_icons()

# Goes to the previous page.
func prev_page():

	if cur_page > 0:
		
		# Hides current page.
		get_node("CanvasLayer/interface/page_" + str(cur_page)).hide()
		
		# Shows next page.
		cur_page -= 1
		get_node("CanvasLayer/interface/page_" + str(cur_page)).show()
		
		# Update interaction icons.
		update_icons()
		
# Updates the interaction icons.
func update_icons():
	
	if cur_page > 0:
		$CanvasLayer/interface/icon_page_left.show()
	else:
		$CanvasLayer/interface/icon_page_left.hide()
		
	if cur_page < pages - 1:
		$CanvasLayer/interface/icon_page_right.show()
	else:
		$CanvasLayer/interface/icon_page_right.hide()