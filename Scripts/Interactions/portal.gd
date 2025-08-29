extends Node2D

@export_group("Properties")
@export var texture: Texture
@export var animatedSprite: SpriteFrames
@export var animeName: StringName = "default"
@export var textureScale: float = 1.0
@export var collisionShape: Shape2D

@export_enum("Right", "Left") var direction: int = 0

@export_group("Others")
@export var parent: Node
@export var player: CharacterBody2D


@onready var area: Area2D = $Area2D
@onready var spawn_position: Marker2D = $Area2D/SpawnPosition

@onready var sprite: Sprite2D = $Sprite2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D


func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if !direction:
		area.scale = -abs(area.scale)
	elif direction:
		area.scale = abs(area.scale)

func apply_properties() -> void:
	if animatedSprite:
		texture.texture = null
		animated_sprite.sprite_frames = animatedSprite
		animated_sprite.scale.x = textureScale
		animated_sprite.scale.y = textureScale
		
		if !animatedSprite.is_playing():
			animated_sprite.play(animeName)
	
	elif texture:
		animated_sprite.stop()
		sprite.texture = texture
		sprite.scale.x = textureScale
		sprite.scale.y = textureScale
	
	
	if collisionShape:
		collision_shape.shape = collisionShape


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		print("yaaaay")
		parent.connected_portal = self
