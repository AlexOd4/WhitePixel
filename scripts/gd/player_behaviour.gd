class_name Player extends CharacterBody2D

@export var movement_distance: Vector2 = Vector2.ONE
@export var movement_turn: int = 1:
	set(value):
		movement_turn = clamp(value, 1, INF)

@onready var movement_size: Vector2 = $Sprite2D.scale

@onready var near_ray: RayCast2D = $NearRay
@onready var far_ray: RayCast2D = $FarRay

func _ready() -> void:
	Global.movement_input.connect(_on_movement_input)
	near_ray.target_position = movement_size * movement_distance
	far_ray.target_position = movement_size * 2 * movement_distance
func _on_movement_input(global_movement_counter: int, movement_direction: Vector2) -> void:
	if not global_movement_counter % movement_turn == 0: return
	
	near_ray.target_position = movement_size * movement_direction * movement_distance
	far_ray.target_position = movement_size * 2 * movement_direction * movement_distance
	#print(global_position-(Vector2(Vector2i(global_position) + movement_direction * movement_size * movement_distance)))
	call_deferred("movement_and_comprovements", movement_direction)

func movement_and_comprovements(movement_direction:Vector2):
	if near_ray.is_colliding(): return
	global_position = Vector2(global_position + movement_direction * movement_size * movement_distance)
