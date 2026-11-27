## Spawns the asteroids of each level and keeps the score, level and asteroid count up to date.
extends Node

const PLAYER_MIN_DISTANCE := 20.0

@export var asteroid_scene: PackedScene
@export var asteroids_per_level := 2

var level := 1: set = _set_level
var score := 0: set = _set_score
var asteroids_left := 0: set = _set_asteroids_left

var _displayed_score := 0
var _score_tween: Tween

@onready var player: CharacterBody2D = $"../Player"
@onready var game_area: GameArea = $"../GameArea"
@onready var level_label: Label = $"../CanvasLayer/GameInfo/LevelLabel"
@onready var score_label: Label = $"../CanvasLayer/GameInfo/ScoreLabel"
@onready var asteroids_label: Label = $"../CanvasLayer/AsteroidsLabel"


func _ready() -> void:
	assert(asteroid_scene, "Asteroid scene missing in the manager")
	_spawn_asteroids(level * asteroids_per_level)


func _spawn_asteroids(amount: int) -> void:
	for i in amount:
		var asteroid := asteroid_scene.instantiate() as Asteroid
		asteroid.position = _get_random_position()
		for j in randi_range(0, 2):
			asteroid.shrink()
		add_child.call_deferred(asteroid)
	asteroids_left = amount


# Keeps new asteroids out of a band around the player on both axes,
# so a level never starts with a rock on top of the ship.
func _get_random_position() -> Vector2:
	var x := -1.0
	while x < 0 or absf(x - player.position.x) < PLAYER_MIN_DISTANCE:
		x = randf_range(0, 320)
	var y := -1.0
	while y < 0 or absf(y - player.position.y) < PLAYER_MIN_DISTANCE:
		y = randf_range(0, 180)
	return Vector2(x, y)


func _on_child_entered_tree(asteroid: Asteroid) -> void:
	if not asteroid:
		return
	asteroid.died.connect(func(points: int): score += points)
	# A rock that splits on the edge can drop its pieces outside the game area.
	# They never trigger body_exited, so they would drift away forever.
	asteroid.global_position = game_area.wrap_point(asteroid.global_position)


func _on_child_exiting_tree(asteroid: Asteroid) -> void:
	if not asteroid:
		return
	asteroids_left = get_child_count() - 1
	if asteroids_left == 0:
		level += 1
		_spawn_asteroids(level * asteroids_per_level)


func _set_level(value: int) -> void:
	level = value
	level_label.text = "Level: %d" % value

	var tween := create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(level_label, "scale", Vector2(1.25, 1.25), 0.35)
	tween.tween_property(level_label, "scale", Vector2.ONE, 0.35)


func _set_score(value: int) -> void:
	score = value
	# Points can come in faster than the count, so restart it from where it is.
	if _score_tween:
		_score_tween.kill()
	_score_tween = create_tween()
	_score_tween.tween_method(_show_score, _displayed_score, score, 0.25)


func _show_score(value: float) -> void:
	_displayed_score = int(value)
	score_label.text = "Score: %d" % _displayed_score


func _set_asteroids_left(value: int) -> void:
	asteroids_left = value
	asteroids_label.text = "Asteroids: %d" % value
