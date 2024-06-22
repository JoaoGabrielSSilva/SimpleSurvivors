extends CanvasLayer

@onready var labelTimer = %LabelTimer
@onready var labelOuro = %LabelOuro



func _process(delta):
	
	labelTimer.text = GameManager.tempo_corrido_string
