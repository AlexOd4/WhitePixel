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

var direction: Vector2i#:
var id: Dictionary[String, StringName] = {
	"up" : &"game_up",
	"down" : &"game_down",
	"left" : &"game_left",
	"right" : &"game_right",
}
@onready var areas: Array[Area2D] = [
	$Areas/AreaLeft, $Areas/AreaUpLeft, $Areas/AreaUp, $Areas/AreaUpRight,
	$Areas/AreaRight, $Areas/AreaDown, $Areas/AreaDown, $Areas/AreaDownLeft
]

var body_collided: Node2D


func _ready() -> void:
	invert_movement(movement_invert_x, movement_invert_y)
	block_movement(movement_block_up, movement_block_down, movement_block_left, movement_block_right)
	for area in areas:
		area.area_entered.connect(_on_area_entered.bind(area))
		area.area_exited.connect(_on_area_exited.bind(area))
		area.body_entered.connect(_on_body_entered.bind(area))
		area.body_exited.connect(_on_body_exited.bind(area))
		
func _physics_process(delta: float) -> void:
	# We stops the movements due transitions between scenes
	if not Global.can_move: return
	# We get a Vector 2 of integers with the direction of movement in player Input
	direction = Vector2i(
		roundi(Input.get_axis(id.left, id.right)) * inverter.x, #direction.x
		roundi(Input.get_axis(id.up, id.down)) * inverter.y		#direction.y
	)
	# We get a state of action_just_pressed of all player control inputs
	var action_pressed: bool = (
		Input.is_action_just_pressed("game_left") or Input.is_action_just_pressed("game_right") or
		Input.is_action_just_pressed("game_up") or Input.is_action_just_pressed("game_down")
	)
	
	if action_pressed and direction:
		var kinematic_collision: KinematicCollision2D = move_and_collide(direction * current_movement_dist, false, 0.0)
	

func _on_area_entered(area: Area2D, my_area:Area2D):
	pass

func _on_area_exited(area: Area2D, my_area:Area2D):
	pass

func _on_body_entered(area: Node2D, my_area:Area2D):
	pass

func _on_body_exited(area: Node2D, my_area:Area2D):
	pass

#region CUSTOM Func
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
#endregion
