extends API
class_name PaymentsAPI

const sku_list = [
	"iap_support_1_dollar",
]

signal purchase_confirmed
signal purchase_error

func purchase_item(item_name: String) -> void:
    pass