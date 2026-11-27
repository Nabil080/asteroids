## A rock drifting in a random direction. When destroyed it splits in smaller rocks,
## until it is too small to split.
class_name Asteroid
extends RigidBody2D

signal died(points: int)

@export_group("Motion")
@export var min_speed := 10.0
@export var max_speed := 30.0
## Spin in rad/s, negative turns left.
@export var min_spin := -2.0
@export var max_spin := 2.0

@export_group("Splitting")
## How many more times this rock can split. Also picks the points it gives.
@export var divisions_left := 2
@export var pieces := 2


func _ready() -> void:
	linear_velocity = Vector2.from_angle(randf() * TAU) * randf_range(min_speed, max_speed)
	angular_velocity = randf_range(min_spin, max_spin)


func shrink() -> void:
	divisions_left -= 1
	_multiply_scale(1.0 / pieces)
	$HealthComponent.max_health /= 2
	$CPUParticles2D.scale_amount_max /= 2
	$CPUParticles2D.scale_amount_min /= 2


func _multiply_scale(factor: float) -> void:
	$RandomSprite.scale *= factor
	$CollisionShape2D.scale *= factor
	$HitboxComponent/CollisionShape2D.scale *= factor
	$HurtboxComponent/CollisionShape2D.scale *= factor
	$HealthBarComponent.scale *= factor
	$HealthBarComponent.position *= factor


func _on_health_component_health_depleted() -> void:
	died.emit([100, 50, 20][divisions_left])
	if divisions_left:
		shrink()
		for i in pieces:
			get_parent().add_child.call_deferred(duplicate())
	# Particles and sound outlive the rock, so they move to the scene before it is freed.
	$CPUParticles2D.emitting = true
	$CPUParticles2D.reparent(get_tree().current_scene)
	$DeathSound.play()
	$DeathSound.reparent(get_tree().current_scene)
	queue_free()
