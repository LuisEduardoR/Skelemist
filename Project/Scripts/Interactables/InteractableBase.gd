# Base class for interactable objects.
extends Node2D

# Used to indicate if an interactions should be allowed.
export var allow_interaction_e = false
export var allow_interaction_r = false
export var allow_interaction_t = false

# Icons for each type of interaction.
export(Texture) var interaction_icon_e = null
export(Texture) var interaction_icon_r = null
export(Texture) var interaction_icon_t = null

# Functions to check if each interaction is avaliable.
func is_e_avaliable(player):
	return allow_interaction_e

func is_r_avaliable(player):
	return allow_interaction_r
	
func is_t_avaliable(player):
	return allow_interaction_t

# Functions for each interaction button, intended to be overwritten by other scripts.
func interact_e(player):
	print("Warning: empty interaction E was called!")

func interact_r(player):
	print("Warning: empty interaction R was called!")
	
func interact_t(player):
	print("Warning: empty interaction T was called!")