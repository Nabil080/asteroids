## Wraps anything that leaves the screen around to the opposite edge.
class_name GameArea
extends Area2D

var min_bound: Vector2
var max_bound: Vector2


func _ready() -> void:
	var shape := $CollisionShape2D.shape as RectangleShape2D
	var half_size := shape.size / 2
	min_bound = $CollisionShape2D.global_position - half_size
	max_bound = $CollisionShape2D.global_position + half_size


func wrap_point(point: Vector2) -> Vector2:
	return Vector2(wrapf(point.x, min_bound.x, max_bound.x), wrapf(point.y, min_bound.y, max_bound.y))


func _on_body_exited(body: Node2D) -> void:
	body.global_position = wrap_point(body.global_position)
