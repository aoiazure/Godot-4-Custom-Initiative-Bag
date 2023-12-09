extends Node

const SFX: Dictionary = {
	"add": "res://assets/sfx/SOTE_SFX_UI_Parchment_3_v1.ogg",
	"draw": "res://assets/sfx/SOTE_SFX_CardSelect_v2.ogg",
	"end_turn": "res://assets/sfx/SOTE_SFX_UIClick_2_v2.wav",
	"exhaust": "res://assets/sfx/SOTE_SFX_ExhaustCard.ogg",
	"shuffle": "res://assets/sfx/STS_SFX_CardDeal8_v1.ogg",
	"end_round": "res://assets/sfx/SOTE_SFX_EndTurn_v2.ogg",
}


func play_sound(path: String) -> void:
	if not ResourceLoader.exists(path):
		return
	
	var sound: AudioStream = ResourceLoader.load(path) as AudioStream
	var ap: AudioStreamPlayer = AudioStreamPlayer.new()
	get_tree().root.add_child(ap)
	ap.stream = sound
	ap.play()
	await ap.finished












