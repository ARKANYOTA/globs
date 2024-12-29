extends Menu

var ack_text = """[center][font_size=6][u]{code}:[/u] ArkanYota, Theobosse
[u]{code_art}:[/u] NotGoyome, Yolwoocle
[u]{music}:[/u] Strochnis
[u]{special_thanks}:[/u] Artichaut, Alexis, Mark Brown

[u]{assets_tools}:[/u] Poppins (font), Kenney, Deep-fold, freesound (Froey_), ChipTone
[u]{libraries}:[/u] DiscordRPCGodot (vaporvee), GodotPlayGameServices (Iakobs), GodotSteam (GodotSteam)
{godot}
{gmtk}
[/font_size][/center]"""

func _process(delta):
    %AcknowledgementsDescription.text = ack_text.format({
        "code": tr("CREDITS_CODE"),
        "code_art": tr("CREDITS_CODE_ART"),
        "music": tr("MENU_LABEL_MUSIC"),
        "special_thanks": tr("CREDITS_SPECIAL_THANKS"),
        "assets_tools": tr("MENU_CREDITS_ASSETS_TOOLS"),
        "libraries": tr("MENU_CREDITS_LIBRARIES"),
        "godot": tr("MENU_CREDITS_GODOT"),
        "gmtk": tr("MENU_CREDITS_GMTK"),
    })