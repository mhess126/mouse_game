extends Control

@onready var stamina_bar: TextureProgressBar = $StaminaControl/StaminaBar

func set_stamina_meter(value):
	stamina_bar.value = value
