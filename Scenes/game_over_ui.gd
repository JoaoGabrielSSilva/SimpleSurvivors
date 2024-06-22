class_name GameOverUI
extends CanvasLayer

@onready var labelTempo : Label = %LabelTempo
@onready var labelInimigos: Label = %LabelInimigos

@export var atrasoReinicio: float = 5.0
var cooldownReinicio: float
var tempoSobrevivido: String



func _ready():
	labelTempo.text = GameManager.tempo_corrido_string
	labelInimigos.text = str(GameManager.contador_inimigos_derrotados)
	cooldownReinicio = atrasoReinicio

func _process(delta):
	cooldownReinicio -= delta
	if cooldownReinicio <= 0.0:
		reiniciarJogo()
		

func reiniciarJogo():
	GameManager.resetar()
	get_tree().reload_current_scene()
