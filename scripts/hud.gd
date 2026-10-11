extends Control

@onready var stamina_bar: TextureProgressBar = $StaminaControl/StaminaBar
@onready var stamina_number: Label = $StaminaControl/StaminaNumber

func set_stamina_meter(value):
	stamina_bar.value = value
	stamina_number.text = str(value)
