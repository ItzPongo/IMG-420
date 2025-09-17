extends Area2D

@export var speed: float = 600.0
var velocity: Vector2 = Vector2.ZERO
var target_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	# Connect signals for detecting mobs
	self.area_entered.connect(_on_area_entered)
	self.body_entered.connect(_on_body_entered)

	# Calculate velocity toward the target
	if target_position != Vector2.ZERO:
		velocity = (target_position - global_position).normalized() * speed

func _process(delta: float) -> void:
	# Move the bullet
	position += velocity * delta

	# Remove if bullet goes off-screen
	if not get_viewport_rect().has_point(global_position):
		queue_free()

# Collision with mobs if they are Area2D
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("mobs"):
		area.queue_free()  # remove mob
		queue_free()       # remove bullet

# Collision with mobs if they are PhysicsBody2D (RigidBody2D, CharacterBody2D, etc.)
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("mobs"):
		body.queue_free()  # remove mob
		queue_free()       # remove bullet
