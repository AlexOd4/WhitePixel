extends CanvasLayer

var scene_to_changue:PackedScene


func to_scene(scene_path:String) -> void:
	$AnimationPlayer.animation_finished.connect(_change_scene)
	scene_to_changue = load(scene_path)
	$AnimationPlayer.play("transition_start")

func _change_scene(anim_name: StringName) -> void:
	$AnimationPlayer.animation_finished.disconnect(_change_scene)
	get_tree().change_scene_to_packed(scene_to_changue)
	$AnimationPlayer.play("transition_end")
	
