extends Resource

# Id used to identify this element in.
export var id = "new_element"

# Name to be used to refer to the element in text.
export var name = "New Element"
# Texture to be used for the element.
export(Texture) var texture

# Result element id if used on the derivation table.
export var derivative_id = "salt"
# Result element id if used on the transmutation table.
export var transmutated_id = "salt"