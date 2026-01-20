class_name MovingArea2D extends MovableArea2D

@export var base_directions: Array[Vector2] = [Vector2.DOWN]
@onready var base_direction: Vector2 = base_directions[0]

var index: int:
	set(value):
		if value >= base_directions.size():
			value = 0
		index = value
	
func _ready() -> void:
	super._ready()
	near_area.position = base_direction * movement_distance
	self.area_entered.connect(_on_area_entered)

func _on_movement_input(global_movement_counter: int, _movement_direction:Vector2) -> void:
	if  not global_movement_counter % movement_turn == 0: return
	
	move(base_direction)
	
	if not near_area.has_overlapping_bodies(): return
	
	if base_directions.size() <= 0: printerr("ERROR")
	elif base_directions.size() == 1: base_direction = -base_direction
	else: next_direction()
		
	near_area.position = base_direction * movement_distance

func next_direction() -> void:
	index += 1
	base_direction = base_directions[index]

func _on_area_entered(area: Area2D) -> void:
	if not area == get_tree().get_first_node_in_group("Player"): return
	area.queue_free()
	Transition.reset()
