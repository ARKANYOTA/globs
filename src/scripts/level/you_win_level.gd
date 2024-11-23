extends Level

@onready var label = $Label
@onready var animation_player = $AnimationPlayer

var main_contributors = [
	_get_credit_text("CREDITS_CODE", "ArkanYota", "Nolan Carlisi"),
	_get_credit_text("CREDITS_CODE", "Theobosse", "Théodore Billotte"),
	_get_credit_text("CREDITS_CODE_ART", "Yolwoocle", "Léo Bernard"),
	_get_credit_text("CREDITS_CODE_ART", "Notgoyome", "Guillaume Tran"),
	_get_credit_text("MENU_LABEL_MUSIC", "Strochnis"),
]

var credits = [
		_get_credit_text("CREDITS_A_GAME_BY", "Ninesliced"),
	] + _get_main_contributors() + [
		_get_credit_text("CREDITS_SPECIAL_THANKS", "Artichaut", "Léo Lanteri Thauvin"),
		_get_credit_text("CREDITS_SPECIAL_THANKS", "Alexis"),
		_get_credit_text("CREDITS_SPECIAL_THANKS", "Kenney"),
		_get_credit_text("CREDITS_SPECIAL_THANKS", "Mark Brown"),

		_get_credit_text("CREDITS_MADE_USING", "Godot Engine"),

		_get_credit_text("", "MENU_THANK_YOU", ""),
		# _get_credit_text("", "", "(c) 2024 All rights reseved."),
	]

var current_text_i = 0

func _get_credit_text(role = "", title = "", subtitle = ""):
	var template = """[center][font_size=6][color=gray]
	{0}[/color][/font_size][font_size=12]
	{1}[/font_size][font_size=8]
	{2}[/font_size][/center]"""
	
	return template.format([tr(role), tr(title), tr(subtitle)])

func _get_main_contributors():
	main_contributors.shuffle()
	return main_contributors

func _start_credits():
	while current_text_i < credits.size():
		label.text = credits[current_text_i]

		animation_player.play("fade_in_text")
		await animation_player.animation_finished
		
		current_text_i += 1
	
	_show_star()

func _show_star():
	var tween = GameManager.create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($Goal, "position", Vector2(120, 24), 4)

func _ready():
	super()
	_start_credits()

	if GameManager.achievement_manager:
		GameManager.achievement_manager.grant("ACH_COMPLETE_MAIN_GAME")

func _process(delta):
	pass
