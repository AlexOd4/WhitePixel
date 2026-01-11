extends Node

signal movement_input(global_movement_counter: int, movement_direction:Vector2)

var is_loading:bool = false
var movement_counter:int = 0:
	set(value):
		if is_holding: await get_tree().create_timer(.25).timeout
		if not only_one_direction: return
		if stop_adding_counter: return
		is_holding = true
		
		if movement_counter == value: return
		movement_counter = value
		movement_input.emit(movement_counter, direction)
		
	
var stop_adding_counter: bool
var is_holding: bool
var only_one_direction: bool
var direction: Vector2i:
	set(value):
		if value.x and not value.y: only_one_direction = true
		elif not value.x and value.y: only_one_direction = true
		elif value.x and value.y: only_one_direction = false
		elif not value.x and not value.y: only_one_direction = false
		
		if value.x and value.y: return
		direction = value
var tween_text: Tween

func _input(event: InputEvent) -> void:
	
	if is_loading: movement_counter = 0; return
	
	if not (	event.is_action("game_up") or event.is_action("game_down") or
		event.is_action("game_left") or event.is_action("game_right")
		): return
	
	direction = Vector2(
		roundf(Input.get_axis("game_left", "game_right")), 
		roundf(Input.get_axis("game_up", "game_down"))
	)
	
	
	
	if event.is_pressed():
		stop_adding_counter = false
		movement_counter += 1
	elif event.is_released():
		stop_adding_counter = true
		is_holding = false
	
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
