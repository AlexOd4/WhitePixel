class_name MovableCharacter extends CharacterBody2D

@export var is_player: bool

@export_group("Movement", "movement")
@export var movement_distance: int = 10
@export_subgroup("Invert", "movement_invert")
@export var movement_invert_x: bool
@export var movement_invert_y: bool
var inverter: Vector2i = Vector2i.ONE
@export_subgroup("Block", "movement_block")
@export var movement_block_up: bool
@export var movement_block_down: bool
@export var movement_block_right: bool
@export var movement_block_left: bool
var current_movement_dist: int = movement_distance

var id: Dictionary[String, StringName] = {
	"up" : &"game_up",
	"down" : &"game_down",
	"left" : &"game_left",
	"right" : &"game_right",
}


func _ready() -> void:
	invert_movement(movement_invert_x, movement_invert_y)
	block_movement(movement_block_up, movement_block_down, movement_block_left, movement_block_right)

func _physics_process(delta: float) -> void:
	if not Global.can_move: return
	var direction: Vector2 = Vector2(
		roundi(Input.get_axis(id.left, id.right)) * inverter.x, #direction.x
		roundi(Input.get_axis(id.up, id.down)) * inverter.y		#direction.y
	)
	
	var action_pressed: bool = (
		Input.is_action_just_pressed("game_left") or Input.is_action_just_pressed("game_right") or
		Input.is_action_just_pressed("game_up") or Input.is_action_just_pressed("game_down")
	)

	if action_pressed and direction:
		move_and_collide(direction * current_movement_dist)

func invert_movement(inv_x: bool = false, inv_y: bool = false):
	if inv_x: inverter.x = -1
	else: inverter.x = 1
	if inv_y: inverter.y = -1
	else: inverter.y = 1

func block_movement(block_up: bool = false, block_down: bool = false, block_left: bool = false, block_right: bool = false):
	if movement_block_up: id.up = "none"
	else: id.up = &"game_up"
	if movement_block_down: id.down = "none"
	else: id.down = &"game_down"
	if movement_block_left: id.left = "none"
	else: id.left = &"game_left"
	if movement_block_right: id.right = "none"
	else: id.right = &"game_right"
