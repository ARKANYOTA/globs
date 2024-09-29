extends UIButton
class_name PurchaseButton

@export var purchased_item: String 

func _ready():
	if GameManager.payments_api:
		GameManager.payments_api.on_purchase_confirm.connect(_on_purchase_confirm)
		GameManager.payments_api.on_purchase_error.connect(_on_purchase_error)

func _on_pressed():
	super()
	if GameManager.payments_api: 
		if purchased_item:
			GameManager.payments_api.purchase_item(purchased_item)
		else:
			print("Error while trying to purchase: no item to purchase is defined in ", name)
	else:
		print("Error while trying to purchase: no payments api is defined")

func _on_purchase_confirm():
	pass

func _on_purchase_error():
	pass