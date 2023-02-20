extends Node

signal reload_main_menu # For forcing the main menu to check whether save games exist or not
# to display correct button schema

signal change_font_size(new_size)

signal toggle_mouse_capture

signal begin_endscene
signal begin_endgame


# Player blackout signal. Will trigger fade from black to alpha?
signal player_fadein


# Footstep audio signals
signal change_floor
signal play_footsteps
signal stop_footsteps


# Day control
signal start_day
signal end_day


# Coffee machine signals
signal start_display
signal display_finished
signal water_taken
signal grounds_taken
signal coffee_made


# Signals for player
signal drank_coffee
signal took_shower
signal left_for_work
signal jump
