extends Node

@export var velocidade:float = 1

var enemy: Inimigo
var sprite: AnimatedSprite2D 



func _ready():
	enemy = get_parent()
	sprite = enemy.get_node("AnimatedSprite2D")

func _physics_process(delta):
	
	if GameManager.jogo_acabou: return
	
	var posJogador = GameManager.posJogador
	var diferenca = posJogador - enemy.position
	var vetorEntrada = diferenca.normalized()
	enemy.velocity = vetorEntrada * velocidade * 100.0
	
	enemy.move_and_slide()
	
	if vetorEntrada.x > 0:
		sprite.flip_h = false
	elif vetorEntrada.x < 0:
		sprite.flip_h = true
