class_name Transitioner extends Area2D

@export var scene_to_changue: Name.Level

func _ready() -> void:
	self.area_entered.connect(_on_area_entered)
	
func _on_area_entered(area:Area2D):
	if not area == get_tree().get_first_node_in_group("Player"): return
	area.queue_free()
	Transition.to_scene(Name.LEVELS[scene_to_changue])
