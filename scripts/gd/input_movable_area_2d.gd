class_name InputMovableArea2D extends MovableArea2D

@onready var far_area: Area2D = $FarArea


func _ready() -> void:
	Global.movement_input.connect(_on_movement_input)
	near_area.position = movement_distance 
	far_area.position = 2 * movement_distance

func _on_movement_input(global_movement_counter: int, movement_direction: Vector2) -> void:
	if not global_movement_counter % movement_turn == 0: return
	var target_positon: Vector2 = movement_direction * movement_distance
	
	near_area.position = target_positon
	far_area.position = 2 * target_positon
	
	call_deferred("movement_and_comprovements", movement_direction)
func movement_and_comprovements(movement_direction:Vector2):
	await get_tree().create_timer(0.05).timeout
	if near_area.has_overlapping_bodies(): 
		return 
	if far_area.get_overlapping_bodies().filter(func (c): return c is CharacterBody2D): 
		return
	
	if near_area.has_overlapping_areas(): 
		for area in near_area.get_overlapping_areas():
			if not get_tree().get_nodes_in_group("box").has(area): continue
			
			if far_area.has_overlapping_bodies() or far_area.has_overlapping_areas(): 
				return
			area.push(movement_direction, movement_distance)
	
	move(movement_direction)
	$AudioStreamPlayer.pitch_scale = randf_range(.5, 1.5)
	$AudioStreamPlayer.play()
	#global_position = Vector2(global_position + movement_direction * movement_distance)
