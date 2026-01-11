class_name Player extends CharacterBody2D

@export_custom(PropertyHint.PROPERTY_HINT_LINK, "") var movement_distance: Vector2 = Vector2.ONE
@export var movement_turn: int = 1:
	set(value):
		movement_turn = clamp(value, 1, INF)

@onready var near_area: Area2D = $NearArea
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
	if near_area.has_overlapping_bodies(): return
	global_position = Vector2(global_position + movement_direction * movement_distance)
