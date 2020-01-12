extends TileMap

func _ready():
    var size = get_cell_size()
    var offset = size / 2
    for tile in get_used_cells():
        var name = get_tileset().tile_get_name(get_cell(tile.x, tile.y))
        
        var node = load(str("res://world_things/", name, ".tscn")).instance()
        node.global_position = tile * size + offset
        node.set_scale(Vector2(1,1))
        get_parent().call_deferred("add_child", node)
    queue_free()
