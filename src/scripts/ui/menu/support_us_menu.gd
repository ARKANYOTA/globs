extends Menu
class_name SupportUsMenu

func _ready():
	pass

func _process(delta):
	pass


func _on_donate_1_pressed():
	if GameManager.payments_api:
		GameManager.payments_api.purchase_item("iap_support_1_dollar")
