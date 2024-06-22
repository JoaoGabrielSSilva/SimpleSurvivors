extends Node

@export var geradorInimigos: GeradorInimigos
@export var taxaInimigosInicial: float = 60
@export var taxaInimigosPorMinuto: float = 30
@export var duracaoOnda: float = 20
@export var intensidadeOnda: float = 0.5

var tempo: float = 0.0

func _process(delta):
	if GameManager.jogo_acabou: return
	
	tempo += delta
	

	
	var senoOnda = sin((tempo * TAU) / duracaoOnda)
	var fatorOnda = remap(senoOnda, -1.0, 1.0, intensidadeOnda, 1)
	
	var taxaSpawn = taxaInimigosInicial + taxaInimigosPorMinuto * (tempo / 60.0)
	taxaSpawn += fatorOnda
	
	geradorInimigos.inimigosPorMinuto = taxaSpawn
