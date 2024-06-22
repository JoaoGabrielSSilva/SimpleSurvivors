class_name Player
extends CharacterBody2D

@onready var sprite : Sprite2D = $Sprite2D
@onready var animacao : AnimationPlayer = $AnimationPlayer
@onready var areaAtqBase : Area2D = $AreaAtqBase
@onready var AreaRecebimentoDano: Area2D = $AreaRecebimentoDano
@onready var barraVida : ProgressBar = $BarraVida

@export_category("Variáveis do Jogador")
@export var velocidade: float = 3
@export var danoEspada: int = 2
@export var prefabMorte: PackedScene
@export var vida: int = 100
@export var VIDA_MAXIMA : int = 100



var estaAtacando : bool = false
var estaCorrendo : bool = false
var estavaCorrendo : bool = false
var vetorEntrada : Vector2 = Vector2(0, 0)
var cooldownDano: float = 0.0
var cooldownZona: float = 0.0

func _process(delta):
	GameManager.posJogador = position
	
	vetorEntrada = Input.get_vector("mover_esquerda", "mover_direita", "mover_cima", "mover_baixo")
	animarJogador()
	
	detectarDano(delta)
	
	barraVida.max_value = VIDA_MAXIMA
	barraVida.value = vida
	
	
func _physics_process(delta):

	var velMax = vetorEntrada * velocidade * 100.0
	velocity = lerp(velocity, velMax, 0.9)
	move_and_slide()
	
	
func animarJogador():
	estavaCorrendo = estaCorrendo
	estaCorrendo = not vetorEntrada.is_zero_approx()
	
	if animacao.current_animation == "atacar" && animacao.current_animation_length > 0:
		estaAtacando = false
	else:
		if estavaCorrendo != estaCorrendo:
			if estaCorrendo:
				animacao.animation_set_next("atacar","correr")
				animacao.play("correr")
			else:
				animacao.animation_set_next("atacar", "idle")
				animacao.play("idle")


	girarSprite()

func girarSprite():
	if vetorEntrada.x > 0:
		sprite.flip_h = false
	elif vetorEntrada.x < 0:
		sprite.flip_h = true

func ataquePadrao():
	causarDano(danoEspada)
	estaAtacando = false

func causarDano(dano : int):
	var corpos = areaAtqBase.get_overlapping_bodies()
	
	for corpo in corpos:
		if corpo.is_in_group("inimigos"):
			var inimigo : Inimigo = corpo
			
			var direcaoParaInimigo = (inimigo.position - position).normalized()
			var direcaoAtaque: Vector2
			if sprite.flip_h:
				direcaoAtaque = Vector2.LEFT
			else:
				direcaoAtaque = Vector2.RIGHT
			var dotProduct = direcaoParaInimigo.dot(direcaoAtaque)
			if dotProduct >= 0.5:
				inimigo.dano(dano)

	


func _on_timer_ataque_padrao_timeout():
	animacao.play("atacar")
	estaAtacando = true

func detectarDano(delta):
	cooldownDano -= delta
	if cooldownDano > 0: return
	
	cooldownDano = 0.5
		
	
	var bodies = AreaRecebimentoDano.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("inimigos"):
			var inimigo: Inimigo = body
			var qtdDano = 1
			dano(qtdDano)
	pass


func dano(quantidade: int):
	if vida <= 0: return
	vida -= quantidade
	
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	if vida <= 0:
		morrer()
		
func morrer():
	GameManager.finalizarJogo()
	if prefabMorte:
		var objetoMorte = prefabMorte.instantiate()
		objetoMorte.position = position
		get_parent().add_child(objetoMorte)
		
	queue_free()

func curar(quantidade : int):
	vida += quantidade
	if vida > VIDA_MAXIMA:
		vida = VIDA_MAXIMA
	
	return vida
	

