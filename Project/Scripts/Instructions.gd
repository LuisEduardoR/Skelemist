extends Node2D

# Images used for the pages.
export var pages = []

# Current page.
var cur_page

func _ready():
	
	cur_page = 0;
	$page.set_texture(pages[cur_page])
	update_icons()

# Goes to the next page.
func next_page():
	
	if cur_page < pages.size() - 1:
		cur_page += 1
		$page.set_texture(pages[cur_page])
		
		update_icons()

# Goes to the previous page.
func prev_page():

	if cur_page > 0:
		cur_page -= 1
		$page.set_texture(pages[cur_page])
		
		update_icons()
		
# Updates the page changing icons.
func update_icons():
	
	if cur_page > 0:
		$page/icon_page_left.show()
	else:
		$page/icon_page_left.hide()
		
	if cur_page < pages.size() - 1:
		$page/icon_page_rigth.show()
	else:
		$page/icon_page_rigth.hide()