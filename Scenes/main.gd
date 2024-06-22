extends Node2D

@export var gameUI: CanvasLayer
@export var gameOverUITemplate: PackedScene

func _ready():
	GameManager.fimDeJogo.connect(ativarFimDeJogo)

func ativarFimDeJogo():
	if gameUI:
		gameUI.queue_free()
		gameUI = null
		
	var gameOverUI: GameOverUI = gameOverUITemplate.instantiate()
	add_child(gameOverUI)
