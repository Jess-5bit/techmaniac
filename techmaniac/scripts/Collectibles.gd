extends Node

var COLLECTIBLES : Array = Utilities.load_data_from_json("res://data/items.json")["items"]

func get_collectible_sprite_frame(index : int) -> int:
	return COLLECTIBLES[index]["frame"]

func get_collectible_quip(index : int) -> String:
	return COLLECTIBLES[index]["quip"]
