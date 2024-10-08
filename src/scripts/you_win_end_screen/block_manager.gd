extends Node2D
class_name TileMapManager

@export var collision_enabled : bool = true

var tile_set_map_list : Array[TileMapLayer]
var index_tile_set_map : int = 0

func _ready() -> void:
    var childrens = get_children()
    for child in childrens:
        if child is TileMapLayer:
            var tile_set_map : TileMapLayer = child
            tile_set_map_list.append(tile_set_map)
            tile_set_map.collision_enabled = false
            tile_set_map.visible = false

    if collision_enabled:
        tile_set_map_list[index_tile_set_map].collision_enabled = true
        tile_set_map_list[index_tile_set_map].visible = true

func _process(delta: float) -> void:
    pass
    # if Input.is_action_just_pressed("left_click"):
    #     increase_level()

func increase_level():
    tile_set_map_list[index_tile_set_map].collision_enabled = false
    tile_set_map_list[index_tile_set_map].visible = false
    index_tile_set_map = (index_tile_set_map + 1) % tile_set_map_list.size()
    if collision_enabled:
        tile_set_map_list[index_tile_set_map].collision_enabled = true
        tile_set_map_list[index_tile_set_map].visible = true