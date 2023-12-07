class_name Token extends Texture2D

@export var name: String
@export var details: String


## Make it easy to create one quickly
static func create(_name: String, _details: String) -> Token:
	var token: Token = Token.new()
	token.name = _name
	token.details = _details
	return token


## Required :(
func _get_height() -> int:
	return 0

func _get_width() -> int:
	return 0





