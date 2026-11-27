## Area that receives damage and passes it to a HealthComponent.
## After a hit it ignores damage for a moment and makes the visuals blink.
class_name HurtboxComponent
extends Area2D

@export var enabled := true
@export var health_component: HealthComponent
## Seconds of invincibility after a hit.
@export var damage_cooldown := 0.4
## Blinks during the cooldown. Leave empty for no blink.
@export var visuals: Node2D
@export var blink_interval := 0.08

var _can_take_damage := true
var _blinking := false


func _ready() -> void:
	assert(health_component, "HurtboxComponent needs a HealthComponent")


func apply_damage(amount: int) -> void:
	if not _can_take_damage or not enabled:
		return
	health_component.apply_damage(amount)
	_start_cooldown()


func _start_cooldown() -> void:
	_can_take_damage = false
	if visuals:
		_start_blink()
	await get_tree().create_timer(damage_cooldown).timeout
	if visuals:
		_stop_blink()
	_can_take_damage = true


func _start_blink() -> void:
	if _blinking:
		return
	_blinking = true
	_blink_loop()


func _stop_blink() -> void:
	_blinking = false
	visuals.visible = true


# Stops when disabled so the death animation keeps control of the visuals.
func _blink_loop() -> void:
	while _blinking and enabled:
		visuals.visible = not visuals.visible
		await get_tree().create_timer(blink_interval).timeout
