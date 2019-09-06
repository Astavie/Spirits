extends Node2D

var _religion;

var idle = true;

var jumping = false;
var jump = 0;

var pixels = 0;

var falling = false;
var vspeed = 0;

var correct = false;

signal moved;

func set_religion(religion):
	self._religion = religion;
	get_node("Message/Religion").texture = get_parent().religions[religion];
	if get_parent().seen.find(religion) == -1:
		get_parent().seen.append(religion);
		if get_parent().unique[religion] != null:
			get_node("Sprite").texture = get_parent().unique[religion];

func get_religion():
	return _religion;

func show_message():
	set_active();
	get_node("Message").visible = true;

func has_message():
	return get_node("Message").visible;

func move(i):
	pixels += i;

func fall(i):
	z_index = 1;
	set_active();
	pixels = i;
	falling = true;

func set_active():
	idle = false;
	get_node("Sprite").flip_h = pixels < 0;

func hide_message():
	get_node("Message").visible = false;

func _process(delta):
	var gate = get_node("../gate");
	if !falling && position.x > 104 && position.x < 110:
		gate.open();
	
	if idle && randf() > 0.995:
		var sprite = get_node("Sprite");
		sprite.flip_h = !sprite.flip_h;
		jumping = true;
	
	if pixels != 0:
		if falling:
			vspeed += delta * 2;
			var f = sign(pixels) * min(abs(vspeed), abs(pixels));
			translate(Vector2(0, f));
			var rot = -sign(pixels) * min(abs(vspeed) / 25, 0.04)
			rotate(rot);
			pixels -= f;
			if pixels == 0:
				emit_signal("moved", self);
		else:
			if idle && randf() > 0.80:
				set_active();
			if !idle:
				if pixels < 0:
					get_node("Sprite").flip_h = true;
				jumping = true;
				var f = sign(pixels) * min(delta * 20, abs(pixels));
				translate(Vector2(f, 0));
				pixels -= f;
				if pixels == 0:
					idle = true;
					emit_signal("moved", self);
	
	if jumping:
		var f = delta * 20;
		if jump < 0:
			f = -min(f, -jump);
		translate(Vector2(0, -f));
		jump += abs(f);
		if jump == 0:
			jumping = false;
		if jump > 2:
			jump = -jump;
