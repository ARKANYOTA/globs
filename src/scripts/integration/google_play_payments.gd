extends API

# Matches BillingClient.ConnectionState in the Play Billing Library
enum ConnectionState {
	DISCONNECTED, # not yet connected to billing service or was already closed
	CONNECTING, # currently in process of connecting to billing service
	CONNECTED, # currently connected to billing service
	CLOSED, # already closed and shouldn't be used again
}

# Matches Purchase.PurchaseState in the Play Billing Library
enum PurchaseState {
	UNSPECIFIED,
	PURCHASED,
	PENDING,
}

const sku_list = [
	"iap_test_01",
]

var payment: Object = null

func initialize() -> bool:
	# ...
	if not is_enabled:
		return false
	
	_init_payments()

	is_enabled = true
	return true


func purchase_item(item_name: String):
	payment.purchase(item_name)

########################################################################

func _init_payments():
	if not Engine.has_singleton("GodotGooglePlayBilling"):
		print("[GooglePlay] WARNING: GodotGooglePlayBilling singleton is not present, Android In-App Purchases (IAP) support is not enabled. Make sure you have enabled 'Gradle Build' and the GodotGooglePlayBilling plugin in your Android export settings! IAP will not work.")
		return
	
	payment = Engine.get_singleton("GodotGooglePlayBilling")

	# These are all signals supported by the API
	# You can drop some of these based on your needs
	payment.billing_resume.connect(_on_billing_resume) # No params
	payment.connected.connect(_on_payment_connected) # No params
	payment.disconnected.connect(_on_payment_disconnected) # No params
	# payment.connect_error.connect(_on_connect_error) # Response ID (int), Debug message (string)
	# payment.price_change_acknowledged.connect(_on_price_acknowledged) # Response ID (int)
	# payment.purchases_updated.connect(_on_purchases_updated) # Purchases (Dictionary[])
	# payment.purchase_error.connect(_on_purchase_error) # Response ID (int), Debug message (string)
	
	payment.sku_details_query_completed.connect(_on_product_details_query_completed) # Products (Dictionary[])
	payment.sku_details_query_error.connect(_on_product_details_query_error) # Response ID (int), Debug message (string), Queried SKUs (string[])

	payment.purchase_acknowledged.connect(_on_purchase_acknowledged) # Purchase token (string)
	payment.purchase_acknowledgement_error.connect(_on_purchase_acknowledgement_error) # Response ID (int), Debug message (string), Purchase token (string)
	# payment.purchase_consumed.connect(_on_purchase_consumed) # Purchase token (string)
	# payment.purchase_consumption_error.connect(_on_purchase_consumption_error) # Response ID (int), Debug message (string), Purchase token (string)
	payment.query_purchases_response.connect(_on_query_purchases_response) # Purchases (Dictionary[])

	payment.startConnection()


func _process(_delta):
	if not is_enabled:
		return


func is_payment_ready():
	return payment.isReady()

func _on_payment_connected():
	print("[GooglePlay] GodotGooglePlayBilling connected.")	

	payment.querySkuDetails(sku_list, "inapp") # "subs" for subscriptions

func _on_payment_disconnected():
	print("[GooglePlay] GodotGooglePlayBilling disconnected.")	



func _on_product_details_query_completed(product_details: Dictionary):
	for available_product in product_details:
		print(available_product)
	
	_query_purchases()

func _on_product_details_query_error(response_id: int, error_message: String, products_queried: Array[String]):
	print("on_product_details_query_error id:", response_id, " error_message: ",
			error_message, " products_queried: ", products_queried)



func _query_purchases():
	payment.queryPurchases("inapp") # Or "subs" for subscriptions

func _on_query_purchases_response(query_result: Dictionary):
	if query_result.status == OK:
		for purchase in query_result.purchases:
			pass
			# _process_purchase(purchase) # TODO
	else:
		print("queryPurchases failed, response code: ",
				query_result.response_code,
				" debug message: ", query_result.debug_message)	

func _on_billing_resume():
	if payment.getConnectionState() == ConnectionState.CONNECTED:
		_query_purchases()



func _on_purchases_updated(purchases):
	for purchase in purchases:
		_process_purchase(purchase)

func _on_purchase_error(response_id, error_message):
	# TODO
	print("purchase_error id:", response_id, " message: ", error_message)


## Consumables: not implemented >> see https://docs.godotengine.org/en/stable/tutorials/platform/android/android_in_app_purchases.html#consumables 
## Subscriptions: not implemented 


func _process_purchase(purchase):
	if "iap_test_01" in purchase.products and \
			purchase.purchase_state == PurchaseState.PURCHASED and \
			not purchase.is_acknowledged:
		# Add code to store payment so we can reconcile the purchase token
		# in the completion callback against the original purchase
		payment.acknowledgePurchase(purchase.purchase_token)

func _on_purchase_acknowledged(purchase_token):
	_handle_purchase_token(purchase_token, true)

func _on_purchase_acknowledgement_error(response_id, error_message, purchase_token):
	print("_on_purchase_acknowledgement_error id: ", response_id, " message: ", error_message)
	_handle_purchase_token(purchase_token, false)

# Find the sku associated with the purchase token and award the
# product if successful
func _handle_purchase_token(purchase_token, purchase_successful):
	pass
	# check/award logic, remove purchase from tracking list