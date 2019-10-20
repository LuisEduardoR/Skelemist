# This class is a base template for creating a table that the player can use elements to interact

extends StaticBody2D

var element_dict # Stores a reference to the element dictionary.

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Gets the element dict.
	element_dict = get_node("/root/Node2D/ElementDict")
	
# Override to provide a way to put elements into the table.
func put_element(element_id):
	print_debug("Warning!: put_element function was called without an override!")
	return -1
		
# Override to provide a way to put verify if the table is empty.
func empty():
	print_debug("Warning!: empty function was called without an override!")
	pass

# Override to provide a way to trash current elements in the table.
func trash():
	print_debug("Warning!: trash function was called without an override!")
	pass
