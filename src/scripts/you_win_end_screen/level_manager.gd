extends Node2D

var tile_map_manager_list : Array[TileMapManager] = []

func _ready() -> void:
    var childrens = get_children()
    for child in childrens:
        if child is TileMapManager:
            var tile_map_manager : TileMapManager = child
            tile_map_manager_list.append(tile_map_manager)

func _process(delta: float) -> void:
    if Input.is_action_just_pressed("left_click"):
        increase_all_level()


func increase_all_level():
    for tile_map_manager in tile_map_manager_list:
        tile_map_manager.increase_level()
