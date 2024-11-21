extends Menu

func _on_twitter_button_pressed():
	OS.shell_open("http://x.com/ninesliced")

func _on_website_button_pressed():
	OS.shell_open("http://ninesliced.com/")

func _on_bluesky_button_pressed():
	OS.shell_open("http://bsky.app/profile/ninesliced.com/")

func _on_acknowledgements_button_pressed():
	menu_manager.set_menu("AcknowledgementsMenu")



