extends Node

signal movement_input(global_movement_counter: int)

var is_loading:bool = false
var movement_counter:int = 0:
	set(value):
		movement_counter = value
		movement_input.emit(movement_counter)
var action_pressed: bool

var tween_text: Tween

func _input(event: InputEvent) -> void:
	if is_loading: movement_counter = 0; return
	
	if (event.is_action_pressed("game_up") or event.is_action_pressed("game_down") or
		event.is_action_pressed("game_left") or event.is_action_pressed("game_right")):
			movement_counter += 1
	else: return
	
	_light_scene_text()

#region Custom Funcs

func _light_scene_text() -> void:
	#TODO: fix on changue scene update text
	var text_group = get_tree().get_nodes_in_group("text")
	if text_group == []: return
	if tween_text: tween_text.kill()
	tween_text = get_tree().create_tween().bind_node(text_group[0])
	
	tween_text.tween_property(text_group[0], "modulate", Color.hex(0x88888888), 0.3)
	tween_text.tween_property(text_group[0], "modulate", Color.hex(0x3a3a3a88), 0.5).set_delay(2.0)
	
	text_group[0] = text_group[0] as RichTextLabel
	text_group[0].text = str(movement_counter)

#endregion
