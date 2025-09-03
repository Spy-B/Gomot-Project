extends NPCsState

@export var bulletScene: PackedScene
@export_range(0, 1, 0.05) var fireRate: float = 0.5

@onready var attacking_timer: Timer = $"../../Timers/AttackingTimer"


func enter() -> void:
	print("[Enemy][State]: Attacking")
	parent.status_history.append(self)
	
	attacking_timer.wait_time = fireRate
	attacking_timer.start()

func process_input(_event: InputEvent) -> NPCsState:
	return null

func process_frame(_delta: float) -> NPCsState:
	if parent.damaged:
		return parent.damagingState
	
	if !parent.shoot_ray_cast.get_collider() == parent.player && parent.health > 0:
		return parent.idleState
	
	return null

func process_physics(delta: float) -> NPCsState:
	if !parent.is_on_floor():
		parent.velocity.y += gravity * delta
	
	parent.velocity.x = lerp(parent.velocity.x, 0.0, parent.movementWeight)
	
	parent.move_and_slide()
	
	return null
