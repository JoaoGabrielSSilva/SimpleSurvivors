extends Node

signal fimDeJogo

var player: Player
var posJogador:Vector2
var jogo_acabou: bool = false

var tempo_corrido: float = 0.0
var tempo_corrido_string: String
var contador_inimigos_derrotados: int = 0

func _process(delta):
	tempo_corrido += delta
	var tempo_corrido_segundos : int = floori(tempo_corrido)
	var segundos : int = tempo_corrido_segundos % 60
	var minutos: int = tempo_corrido_segundos / 60 
	
	tempo_corrido_string = "%02d:%02d" % [minutos, segundos]

func finalizarJogo():
	if jogo_acabou: return
	
	jogo_acabou = true
	fimDeJogo.emit()

func resetar():
	player = null
	posJogador = Vector2.ZERO
	jogo_acabou = false
	
	var tempo_corrido = 0.0
	var tempo_corrido_string = "00:00"
	var contador_inimigos_derrotados = 0
	
	for connection in fimDeJogo.get_connections():
		fimDeJogo.disconnect(connection.callable)
