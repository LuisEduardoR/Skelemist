extends "res://Scripts/Interactables/InteractableBase.gd"

# If the box is opened.
var opened

# Must be set to the number of the last page (considering the book starts at 0).
export var last_page = 0

# Current page.
var cur_page

# Stores a reference to the player.
var player

func _ready():
	
	# Initializes the book.
	opened = false
	cur_page = 0;
	
	# Allows this script to run when paused.
	pause_mode = Node.PAUSE_MODE_PROCESS
	
func _process(delta):
	
	# Process interaction when the book is opened.
	if opened:
		if Input.is_action_just_pressed("ui_down"):
			
			# Closes the book.
			opened = false
			
			# Hides the interface.
			$CanvasLayer/interface.hide()
			
			# Resets player state.
			player.set_state(player.previous_state)
			
		if Input.is_action_just_pressed("ui_left"): # Previous page.
			prev_page()
		if Input.is_action_just_pressed("ui_right"): # Next page.
			next_page()

# Opens the book.
func interact_e(player):
	
	opened = true
	
	# Sets the player state.
	player.set_state(player.GAME_STATE.book)
	self.player = player
	
	# Shows the interface.
	$CanvasLayer/interface.show()
	

# Goes to the next page.
func next_page():
	
	if cur_page < last_page:
		
		# Turns on the pages of the book, if coming from the first page.
		if cur_page == 0:
			for i in range(1, last_page + 1):
				get_node("CanvasLayer/interface/page_" + str(i)).show()
		
		# Hides current page.
		get_node("CanvasLayer/interface/page_" + str(cur_page)).hide()
		
		# Updates page number.
		cur_page += 1
		
		# Update interaction icons.
		update_icons()

# Goes to the previous page.
func prev_page():

	if cur_page > 0:
		
		# Updates page number.
		cur_page -= 1
		
		# Shows the page.
		get_node("CanvasLayer/interface/page_" + str(cur_page)).show()
		
		# Hides other pages if this is the first page (cover).
		if cur_page == 0:
			for i in range(1, last_page + 1):
				get_node("CanvasLayer/interface/page_" + str(i)).hide()
		
		# Update interaction icons.
		update_icons()
		
# Updates the interaction icons.
func update_icons():
	
	if cur_page > 0:
		$CanvasLayer/interface/icon_page_left.show()
	else:
		$CanvasLayer/interface/icon_page_left.hide()
		
	if cur_page < last_page - 1:
		$CanvasLayer/interface/icon_page_right.show()
	else:
		$CanvasLayer/interface/icon_page_right.hide()