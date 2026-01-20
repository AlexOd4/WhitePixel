extends Area2D

@export var direction: Vector2 = Vector2.DOWN
@export var movement_treshold: int = 1
@export var level: Name.Level
@onready var movement_size: Vector2 = get_children().filter(func (c): return c is CollisionShape2D)[0].shape.size
@onready var ray: RayCast2D = $RayCast2D


func _ready() -> void:
	Global.movement_input.connect(move)
	self.body_entered.connect(_on_area_2d_body_entered)
	movement_treshold = clamp(movement_treshold, 1, INF)
	ray.target_position = direction * movement_size

func move(global_movement_counter: int) -> void:
	if (global_movement_counter % movement_treshold) != 0: return
	#if not ray.get_collider() is MovableCharacter and not ray.get_collider() == null: 
		#ray.target_position = -ray.target_position
		#direction = -direction
	set_deferred("global_position", global_position + direction * movement_size)
	
	
func _on_area_2d_body_entered(body:Node2D):
	if not body == get_tree().get_first_node_in_group("Player"): return
	
	body.queue_free()
	Transition.to_scene(Name.LEVELS[level])
