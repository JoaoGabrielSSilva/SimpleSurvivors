extends Node2D

@export var quantidadeVida: int = 20

@onready var area2D : Area2D = $Area2D

func _ready():
	area2D.body_entered.connect(on_body_entered)
	

func on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		var player: Player = body
		player.curar(quantidadeVida)
		queue_free()
