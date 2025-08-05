class_name MovableCharacter extends CharacterBody2D


@export var movement_dist: int = 10
var current_movement_dist: int = movement_dist

func _physics_process(delta: float) -> void:
	var x_direction : int =  roundi(Input.get_axis("game_left", "game_right"))
	var y_direction : int = roundi(Input.get_axis("game_up", "game_down"))
	var action_pressed: bool = (
		Input.is_action_just_pressed("game_left") or Input.is_action_just_pressed("game_right") or
		Input.is_action_just_pressed("game_up") or Input.is_action_just_pressed("game_down") 
	)

	if action_pressed and (x_direction or y_direction):
		#self.global_position += 
		move_and_collide(Vector2(x_direction,y_direction) * current_movement_dist)
	
