## Area that deals damage to every HurtboxComponent it overlaps, once per tick.
class_name HitboxComponent
extends Area2D

signal dealt_damage(damage: int)

@export var damage := 1
## Seconds between two hits on the same hurtbox.
@export var tick_rate := 0.4

var _overlapping := {}


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)


func _on_area_entered(area: Area2D) -> void:
	if area is HurtboxComponent:
		_overlapping[area] = true
		_damage_loop(area)


func _on_area_exited(area: Area2D) -> void:
	_overlapping.erase(area)


func _damage_loop(area: HurtboxComponent) -> void:
	while _overlapping.has(area):
		area.apply_damage(damage)
		dealt_damage.emit(damage)
		await get_tree().create_timer(tick_rate).timeout
