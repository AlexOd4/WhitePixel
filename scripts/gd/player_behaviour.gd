class_name MovableCharacter extends CharacterBody2D
@export_group("Movable Character Type", "is")
@export var is_player: bool
@export var is_pushable: bool

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

var direction: Vector2i
var input_id: Dictionary[String, StringName] = {
	"up" : &"game_up",
	"down" : &"game_down",
	"left" : &"game_left",
	"right" : &"game_right",
}

@onready var near_ray: RayCast2D = $NearRay
@onready var far_ray: RayCast2D = $FarRay

var body_collided: Node2D
var can_move: bool = true

func _ready() -> void:
	invert_movement(movement_invert_x, movement_invert_y)
	block_movement(movement_block_up, movement_block_down, movement_block_left, movement_block_right)

func _physics_process(delta: float) -> void:
	# We stops the movements due transitions between scenes
	if not Global.is_loading: return
	# We get a Vector 2 of integers with the direction of movement in player Input
	direction = Vector2i(
		roundi(Input.get_axis(input_id.left, input_id.right)) * inverter.x, #direction.x
		roundi(Input.get_axis(input_id.up, input_id.down)) * inverter.y		#direction.y
	)
	# We get a state of action_just_pressed of all player control inputs
	var action_pressed: bool = (
		Input.is_action_just_pressed("game_left") or Input.is_action_just_pressed("game_right") or
		Input.is_action_just_pressed("game_up") or Input.is_action_just_pressed("game_down")
	)
	
	#if action_pressed and is_player: print(direction, movement_distance)
	if action_pressed:
		near_ray.target_position = direction * movement_distance
		far_ray.target_position = direction * movement_distance * 2
		await get_tree().create_timer(.01).timeout
		
		var near_collider: Node2D = near_ray.get_collider()
		var far_collider: Node2D = far_ray.get_collider()
		can_move = true
		
		if near_collider and ((near_collider is MovableCharacter and not near_collider.is_pushable) or not near_collider is MovableCharacter):
			can_move = false
			#print(self.name," :A")
		#for a player
		elif  is_player and far_collider is MovableCharacter and not far_collider.is_pushable and far_collider.direction == -direction:
			can_move = false
			#print(self.name," :B")
		#for a pushable object that is not player
		elif is_pushable and not is_player and far_collider is MovableCharacter and far_collider.is_pushable and far_collider.direction == -direction:
			can_move = false
			#print(self.name," :C")

		#TODO: make movable objects pushable by player
		if near_collider is MovableCharacter and near_collider.is_pushable :
			near_collider.global_position += Vector2(direction) * near_collider.movement_distance
			#if is_player: print(self.global_position)
			
			#if is_player: self.global_position += Vector2(direction) * movement_distance
		
		if can_move:
			move(direction, movement_distance, self)
		

#region CUSTOM Func
## moves the object in a call_deferred function 
## direction == direction ; movement == movement_distance ; character == MovableCharacter
func move(direction: Vector2i, movement:int, character: MovableCharacter = self):
	character.call_deferred("set_global_position", character.global_position + Vector2(direction) * movement)

func invert_movement(inv_x: bool = false, inv_y: bool = false):
	if inv_x: inverter.x = -1
	else: inverter.x = 1
	if inv_y: inverter.y = -1
	else: inverter.y = 1

func block_movement(block_up: bool = false, block_down: bool = false, block_left: bool = false, block_right: bool = false):
	if movement_block_up: input_id.up = "none"
	else: input_id.up = &"game_up"
	if movement_block_down: input_id.down = "none"
	else: input_id.down = &"game_down"
	if movement_block_left: input_id.left = "none"
	else: input_id.left = &"game_left"
	if movement_block_right: input_id.right = "none"
	else: input_id.right = &"game_right"
#endregion
