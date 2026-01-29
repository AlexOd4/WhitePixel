class_name MovingArea2D extends MovableArea2D

@export var base_directions: Array[Vector2] = [Vector2.DOWN]
@export var do_extra_comprobations: bool
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
	
	
	if near_area.has_overlapping_bodies() or (near_area.has_overlapping_areas() and near_area.get_overlapping_areas()[0] is BoxArea2D):
		for near_areas in near_area.get_overlapping_areas():
			if near_areas.name == "NearArea": 
				return
		
		if base_directions.size() <= 0: printerr("ERROR")
		elif base_directions.size() == 1: base_direction = -base_direction
		else: next_direction()
			
		near_area.position = base_direction * movement_distance
		#it works haha (its a shit)
		if do_extra_comprobations:
			await get_tree().create_timer(0.05).timeout
			
			if base_directions.size() > 1:
				for _index in base_directions.size():
					if near_area.has_overlapping_bodies() or (near_area.has_overlapping_areas() and near_area.get_overlapping_areas()[0] is BoxArea2D):
						next_direction()
						near_area.position = base_direction * movement_distance
						await get_tree().create_timer(0.05).timeout

	move(base_direction)

func next_direction() -> void:
	index += 1
	base_direction = base_directions[index]

func _on_area_entered(area: Area2D) -> void:
	if not area == get_tree().get_first_node_in_group("Player"): return
	area.queue_free()
	Transition.reset()
