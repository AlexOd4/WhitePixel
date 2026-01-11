class_name Transitioner extends Area2D

@export var scene_to_changue: Name.Level


func _ready() -> void:
	self.body_entered.connect(_on_body_entered)
	
	
func _on_body_entered(body:Node2D):
	if not body is Player: return
	body.queue_free()
	Transition.to_scene(Name.LEVELS[scene_to_changue])
