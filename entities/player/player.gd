## The ship: rotates, thrusts with inertia and shoots. Reloads the scene when it dies.
extends CharacterBody2D

## Turned off by the death animation.
@export var enabled := true

@export_group("Shooting")
@export var bullet_scene: PackedScene = preload("res://entities/bullet/bullet.tscn")
@export var damage := 3

@export_group("Thrusting")
@export var max_speed := 200.0
## How fast the ship reaches max speed, and how fast it slows down without thrust.
@export var acceleration := 1.0
@export var friction := 1.0

@export_group("Rotation")
## In rad/s.
@export var rotation_speed := 5.0

var direction: Vector2:
	get: return Vector2.UP.rotated(rotation)

@onready var bullet_marker: Marker2D = $BulletMarker
@onready var bullet_cooldown: Timer = $BulletMarker/CooldownTimer
@onready var thrust_sound: AudioStreamPlayer2D = $ThrustSound


func _physics_process(delta: float) -> void:
	if not enabled:
		return
	_rotate(delta)
	_thrust(delta)
	_shoot()
	move_and_slide()


func _rotate(delta: float) -> void:
	rotation += Input.get_axis("rotate_left", "rotate_right") * rotation_speed * delta


func _thrust(delta: float) -> void:
	if Input.is_action_pressed("thrust"):
		velocity = velocity.lerp(direction * max_speed, acceleration * delta)
		if not thrust_sound.playing:
			thrust_sound.play()
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction * delta)

	if Input.is_action_just_released("thrust"):
		thrust_sound.stop()


func _shoot() -> void:
	if not bullet_cooldown.is_stopped() or not Input.is_action_pressed("shoot"):
		return
	var bullet: Bullet = bullet_scene.instantiate()
	bullet.global_position = bullet_marker.global_position
	bullet.rotation = rotation
	bullet.set_damage(damage)
	get_tree().current_scene.add_child(bullet)
	bullet_cooldown.start()


func _on_health_component_damaged(_amount: int) -> void:
	$HurtSound.play()


func _on_health_component_health_depleted() -> void:
	$AnimationPlayer.play("death")
	await $AnimationPlayer.animation_finished
	get_tree().reload_current_scene()
