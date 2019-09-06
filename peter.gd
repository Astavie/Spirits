extends Sprite

signal moved;

var jumping = false;
var jump = 0;

var pixels = 0;

var falling = false;
var vspeed = 0;

func move(i):
	pixels += i;

func fall(i):
	z_index = 2;
	pixels = i;
	falling = true;

func reset():
	flip_h = false;
	jumping = false;
	jump = 0;
	pixels = 0;
	falling = false;
	vspeed = 0;

func _process(delta):
	var gate = get_node("../gate");
	if !falling && position.x > 104 && position.x < 110:
		gate.open();
	
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
			flip_h = true;
			jumping = true;
			var f = sign(pixels) * min(delta * 20, abs(pixels));
			translate(Vector2(f, 0));
			pixels -= f;
			if pixels == 0:
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
