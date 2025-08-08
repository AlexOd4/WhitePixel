class_name Transitioner extends Area2D

@export_file("*.tscn") var scene_to_changue: String

func _ready() -> void:
	self.body_entered.connect(_on_body_entered)
	
	
func _on_body_entered(body:Node2D):
	if not body is MovableCharacter: return
	if not body.is_player: return
	Transition.to_scene(scene_to_changue)
