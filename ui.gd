extends MarginContainer

@export var default_token_list: Array[Token] = []

@export_group("Drawn Token")
@export var token_name_label: Label
@export var token_details_label: Label

@export_group("Add New")
@export var name_field: LineEdit
@export var quantity_field: SpinBox
@export var details_field: TextEdit
@export var add_button: Button

@export_group("Operations")
@export var draw_button: Button
@export var remove_temp_button: Button
@export var remove_perm_button: Button
@export var shuffle_back_button: Button

@export var end_round_button: Button

@export_group("List of Tokens")
@export var token_list: ItemList


var drawn_token: Token : set = _set_drawn_token

var temp_removed_tokens: Array[Token] = []



func _ready() -> void:
	# Add token
	if name_field:
		name_field.text_changed.connect(_update_add_token_usability)
	if quantity_field:
		quantity_field.value_changed.connect(_update_add_token_usability)
	if add_button:
		add_button.pressed.connect(add_token_to_bag)
	
	# Operations
	if draw_button:
		draw_button.pressed.connect(draw_token_from_bag)
	if remove_temp_button:
		remove_temp_button.pressed.connect(remove_token_from_bag)
	if remove_perm_button:
		remove_perm_button.pressed.connect(remove_token_from_bag.bind(true))
	if shuffle_back_button:
		shuffle_back_button.pressed.connect(shuffle_token_back)
	if end_round_button:
		end_round_button.pressed.connect(end_round)
	
	if token_list:
		token_list.item_selected.connect(_select_token)
	
	for token in default_token_list:
		_add_token_to_list(token)
	



@warning_ignore("narrowing_conversion")
func add_token_to_bag() -> void:
	var token_name: String = name_field.text
	var token_details: String = details_field.text
	var amount: int = quantity_field.value
	
	for i in range(amount):
		var token: Token = Token.create(token_name, token_details)
		_add_token_to_list(token)
	
	name_field.clear()
	details_field.clear()
	quantity_field.value = 0



func draw_token_from_bag() -> void:
	if token_list.item_count == 0:
		return
	
	randomize()
	var i: int = randi_range(0, token_list.item_count - 1)
	token_list.item_selected.emit(i)


func remove_token_from_bag(permanent: bool = false) -> void:
	if not drawn_token:
		return
	
	if not permanent:
		temp_removed_tokens.append(drawn_token)
	drawn_token = null


func shuffle_token_back(token: Token = null) -> void:
	if not token:
		if not drawn_token:
			return
		else:
			token = drawn_token
	_add_token_to_list(token)
	drawn_token = null



func end_round() -> void:
	if drawn_token:
		shuffle_token_back(drawn_token)
		drawn_token = null
	
	for token in temp_removed_tokens:
		shuffle_token_back(token)
	temp_removed_tokens.clear()





func _select_token(idx: int) -> void:
	# Can't select a new one while you have one held already.
	if drawn_token:
		return
	
	var token: Token = token_list.get_item_icon(idx)
	drawn_token = token
	token_list.remove_item(idx)

func _set_drawn_token(token: Token) -> void:
	drawn_token = token
	if not drawn_token:
		if token_name_label:
			token_name_label.text = ""
		if token_details_label:
			token_details_label.text = ""
		return
	
	if token_name_label:
		token_name_label.text = drawn_token.name
	if token_details_label:
		token_details_label.text = drawn_token.details

func _add_token_to_list(token: Token) -> void:
	token_list.add_item(token.name, token)
	token_list.sort_items_by_text()

func _update_add_token_usability(_new_value) -> void:
	var name_present: bool = name_field.text.is_empty()
	var quantity_not_zero: bool = quantity_field.value == 0
	add_button.disabled = name_present or quantity_not_zero










