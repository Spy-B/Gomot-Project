@tool
extends Node2D

var elevator_arrived: bool = true

@export var speedScale: float = 1.0

@export_group("Properties")
@export var texture: Texture
@export var textureScale: float = 1.0
@export var collisionShape: Shape2D

@export_group("Others")
@export var key: Node2D

@export var visiblityNotifier: bool = true


@onready var path_follow: PathFollow2D = $PathFollow2D
@onready var animatable_body: AnimatableBody2D = $AnimatableBody2D

@onready var elevator_sprite: Sprite2D = $AnimatableBody2D/Sprite2D
@onready var collision_shape: CollisionShape2D = $AnimatableBody2D/CollisionShape2D

@onready var activation_key_collision: CollisionShape2D = $AnimatableBody2D/ElevatorActivationKey/CollisionShape2D

@onready var visible_on_screen_notifier: VisibleOnScreenNotifier2D = $AnimatableBody2D/VisibleOnScreenNotifier2D


func _ready() -> void:
	#path_follow.progress = 0
	#path_follow.progress_ratio = 0
	
	apply_properties()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		apply_properties()

#func _physics_process(_delta: float) -> void:
	#pass

func apply_properties() -> void:
	if texture:
		elevator_sprite.texture = texture
	
	
		elevator_sprite.scale.x = textureScale
		elevator_sprite.scale.y = textureScale
	
	if collisionShape:
		collision_shape.shape = collisionShape
	
	collision_shape.position.y = (elevator_sprite.texture.get_height() * elevator_sprite.scale.y) / 2
	
	visible_on_screen_notifier.visible = visiblityNotifier

func interact() -> void:
	var tween: Tween
	
	activation_key_collision.set_deferred("set_disabled", true)
	
	if self.curve != null:
		if path_follow.progress_ratio == 0.0:
			tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT)
			tween.tween_property(path_follow, "progress_ratio", 1.0, 1.0)
		
		if path_follow.progress_ratio == 1.0:
			tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT)
			tween.tween_property(path_follow, "progress_ratio", 0.0, 1.0)


func _on_elevator_activation_key_body_entered(body: Node2D) -> void:
	if body == Global.root_scene.player:
		interact()


func _on_elevator_activation_key_body_exited(body: Node2D) -> void:
	if body == Global.root_scene.player:
		activation_key_collision.set_deferred("set_disabled", false)
