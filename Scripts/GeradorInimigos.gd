class_name GeradorInimigos
extends Node2D

@export var inimigos: Array[PackedScene]
var inimigosPorMinuto: float = 30.0

@onready var path_follow_2d: PathFollow2D = %PathFollow2D
var cooldown: float = 0.0


func _process(delta):
	cooldown -= delta
	if cooldown > 0: return
	
	var intervalo = 60.0 / inimigosPorMinuto
	cooldown = intervalo
	
	var ponto = pegarPonto()
	var world_state = get_world_2d().direct_space_state
	var parametros = PhysicsPointQueryParameters2D.new()
	parametros.position = ponto
	parametros.collision_mask = 0b1001
	var resultado: Array = world_state.intersect_point(parametros, 1)
	if not resultado.is_empty(): return
	
	var indice = randi_range(0, inimigos.size() - 1)
	var cenaInimigo = inimigos[indice]
	var inimigo = cenaInimigo.instantiate()
	inimigo.global_position = ponto
	get_parent().add_child(inimigo)

func pegarPonto():
	path_follow_2d.progress_ratio = randf()
	return path_follow_2d.global_position
