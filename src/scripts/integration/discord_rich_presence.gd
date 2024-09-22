extends API

const DISCORD_RPC_APP_ID = 1282760428954325032
const discord_rpc_world_keys: Dictionary = {
	"1": {"name": "Globs City",    "large_image": "large_city"},
	"2": {"name": "Cheese Den",    "large_image": "large_cheese"},
	"3": {"name": "Chilly Tundra", "large_image": "large_snow"},
	"4": {"name": "Space Colony",  "large_image": "large_space"},
}

var initialized = false

# TODO: add lauch command
# https://docs.vaporvee.com/discord-rpc-godot/utillity_or_other/
# Code is: DiscordRPC.register_command("my-awesome-game://run --full-screen")

func initialize():
	DiscordRPC.app_id = DISCORD_RPC_APP_ID 
	DiscordRPC.start_timestamp = int(Time.get_unix_time_from_system())

	DiscordRPC.register_steam(GameManager.STEAM_APP_ID)
	
	update()


func update():
	var level_data = LevelData.get_current_level_data()
	
	if level_data:
		DiscordRPC.details = "In level %s" % level_data["name"]
	
		if level_data.has("world"):
			var world = level_data["world"]
			if discord_rpc_world_keys.has(world):
				var key = discord_rpc_world_keys[world]
				DiscordRPC.large_image = key["large_image"]
				DiscordRPC.large_image_text = key["name"]
	
			else:
				# No world key was found, you should add it in discord_rpc_world_keys
				DiscordRPC.large_image = "icon_detailed"
				DiscordRPC.details = "In a level"
		
		else:
			# No "world" field defined in level data, you should add it in the field in LevelData.levels
			DiscordRPC.large_image = "icon_detailed"
			DiscordRPC.details = "In a menu"
	
	else:
		DiscordRPC.large_image = "icon_detailed"
		DiscordRPC.details = "In a menu"

	DiscordRPC.refresh()
