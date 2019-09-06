extends Sprite

var shader = preload("res://Dead.shader") as Shader;

func _ready():
	material = ShaderMaterial.new();
	material.set_shader(shader);
	
	material.set_shader_param("color_hair", Color(1, 0, 0));
	material.set_shader_param("color_skin", Color(0, 1, 0));
	material.set_shader_param("color_body", Color(0, 0, 1));
	
	material.set_shader_param("replacement_hair", Color.from_hsv(0.12, randf() * randf(), randf()));
	material.set_shader_param("replacement_skin", Color.from_hsv(0.12, 0.5, 1 - randf() * randf()));
	material.set_shader_param("replacement_body", Color.from_hsv(randf(), randf() * randf(), 1 - randf() * randf()));
