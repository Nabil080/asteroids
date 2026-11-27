## A shot that flies straight, fades out at the end of its life and pops on the first hit.
class_name Bullet
extends RigidBody2D

@export var speed := 200.0
@export var lifetime := 0.75
## Part of the lifetime spent fading out.
@export_range(0.0, 1.0) var fade_ratio := 0.2

var _fade_time: float
var _time_left: float


func _ready() -> void:
	$FireParticles.emitting = true
	linear_velocity = Vector2.UP.rotated(rotation) * speed
	_time_left = lifetime
	_fade_time = lifetime * fade_ratio


func _process(delta: float) -> void:
	_time_left -= delta
	if _time_left <= 0:
		queue_free()
	elif _time_left <= _fade_time:
		modulate.a = _time_left / _fade_time


func set_damage(value: int) -> void:
	$HitboxComponent.damage = value


func _on_hitbox_component_dealt_damage(_damage: int) -> void:
	if is_queued_for_deletion():
		return
	$HitParticles.emitting = true
	$HitParticles.reparent(get_tree().current_scene)
	$HitSound.play()
	$HitSound.reparent(get_tree().current_scene)
	queue_free()
