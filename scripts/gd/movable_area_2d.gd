@abstract
class_name MovableArea2D extends Area2D

@export_custom(PropertyHint.PROPERTY_HINT_LINK, "") var movement_distance: Vector2 = Vector2.ONE * 10
@export var movement_turn: int = 1:
	set(value):
		movement_turn = clamp(value, 1, INF)
		
@onready var near_area: Area2D = $NearArea
var is_being_pushed: bool = false

func _ready() -> void:
	Global.movement_input.connect(_on_movement_input)

#TEST: is_being_pushed
func move(movement_direction: Vector2) -> void:
	if is_being_pushed: is_being_pushed = false; return;
	set_deferred("global_position",  global_position + movement_direction * movement_distance)
func push(movement_direction: Vector2, push_distance: Vector2) -> void:
	is_being_pushed = true
	set_deferred("global_position", global_position + movement_direction * push_distance)


@warning_ignore("unused_parameter")
func _on_movement_input(global_movement_counter: int, movement_direction: Vector2) -> void:
	pass
