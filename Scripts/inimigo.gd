class_name Inimigo
extends Node2D

@export var prefabMorte: PackedScene
@export var vida: int = 10
var prefabDigitoDano: PackedScene

@onready var marcadorDigitoDano = $MarcadorDigitoDano

@export var chanceDrop: float = 0.1
@export var chancesDrop: Array[float]
@export var itensDrop: Array[PackedScene]

func _ready():
	prefabDigitoDano = preload("res://Scenes/digito_dano.tscn")

func dano(quantidade: int):
	vida -= quantidade
	
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	

	var digitoDano = prefabDigitoDano.instantiate()
	digitoDano.valor = quantidade
	if marcadorDigitoDano:
		digitoDano.global_position = marcadorDigitoDano.global_position
	else:
		digitoDano.global_position = global_position
	
	get_parent().add_child(digitoDano)
	
	if vida <= 0:
		morrer()
		
func morrer():
	if prefabMorte:
		var objetoMorte = prefabMorte.instantiate()
		objetoMorte.position = position
		get_parent().add_child(objetoMorte)
		
	if randf() <= chanceDrop:
		droparItem()
		
	GameManager.contador_inimigos_derrotados += 1
	
	queue_free()

func droparItem():
	var drop = pegarItemParaDropar().instantiate()
	drop.position = position
	get_parent().add_child(drop)

func pegarItemParaDropar():
	
	if itensDrop.size() == 1:
		return itensDrop[0]
	
	var chanceMaxima: float = 0.0
	for chanceDrop in chancesDrop:
		chanceMaxima += chanceDrop
		
	var resultadoAleatorio = randf() * chanceMaxima
	
	var agulha: float = 0.0
	for i in itensDrop.size():
		var itemDrop = itensDrop[i]
		var chanceDrop = chancesDrop[i] if i < chancesDrop.size() else 1
		if resultadoAleatorio <= chanceDrop + agulha:
			return itemDrop
		agulha += chanceDrop
	return itensDrop[0]
