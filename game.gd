extends Node2D

var dead_class = preload("res://dead_info.gd");

var dead = preload("res://Dead.tscn");
var age_class = preload("res://age.gd");

var no = preload("res://no.png");
var yes = preload("res://yes.png");

var no_inactive = preload("res://no_inactive.png");

var unique = [
	preload("res://abraham.png"),
	preload("res://jesus.png"),
	null,
	null,
	null,
	null,
	null,
	null,
	null,
	null,
	preload("res://muhammed.png"),
	null,
	preload("res://luther.png"),
	null,
	null,
	null
];

# 0 - Judaism
# 1 - Christianity / Catholicism
# 2 - Oriental Orthodox
# 3 - Eastern Orthodox
# 4 - Buddhism
# 5 - Egyptian
# 6 - Hellenism
# 7 - Hinduism
# 8 - Zoroastrianism
# 9 - Nestorian
# 10 - Islam / Sunni
# 11 - Shi'ah
# 12 - Protestant
# 13 - Non-theist
# 14 - Satanist
# 15 - Pastafarianism

var religions = [
	preload("res://judaism.png"),
	preload("res://catholic.png"),
	preload("res://orthodox_oriental.png"),
	preload("res://orthodox_eastern.png"),
	preload("res://buddhism.png"),
	preload("res://egyptian.png"),
	preload("res://hellenism.png"),
	preload("res://hinduism.png"),
	preload("res://zoroastrianism.png"),
	preload("res://orthodox_nestorian.png"),
	preload("res://sunni.png"),
	preload("res://shia.png"),
	preload("res://protestant.png"),
	null,
	preload("res://satanism.png"),
	preload("res://pastafarian.png")
];

var seen = [];

var screen = 0; # 0 - start, 1 - select, 2 - move up, 3 - game, 4 - game over, 5 - back down
var mode = 0; # 0 - catholic, 1 - protestant, 2 - sunni

var vspeed = 0;

var age = null;
var next = null;

var ages = [];

var checked = 0;

var list = [];

var allowed = [];

var x = 75;
var y = 52;
var spacing = 8;

var failures = 0;

var choice = false;

var time = 0;

func _ready():
	seed(OS.get_time().second);
	get_node("gate").connect("change", self, "play_gate");
	set_process_input(true);

func play_gate():
	get_node("audio_gate").play();

func init_ages():
	if mode == 0: # catholic
		ages = [
			age_class.new([0], [true], [ 0, 0, 4, 5, 5, 5, 6, 6, 6, 7, 7, 8 ], 20, 30, 0), # 6th century BCE
			age_class.new([1], [true], [ 0, 0, 1, 4, 6, 6, 6, 6, 6, 7, 7, 8 ], 20, 30, 1), # 1st century CE
			age_class.new([0, 2], [false, true], [ 0, 1, 1, 1, 2, 4, 6, 7, 7, 7, 8, 9 ], 10, 15, null), # 5th century CE
			age_class.new([], [], [ 0, 1, 1, 1, 2, 4, 7, 7, 8, 9, 10, 11 ], 10, 15, 10), # 7th century CE
			age_class.new([2, 3], [false, true], [ 0, 1, 1, 2, 3, 4, 7, 8, 9, 10, 10, 11 ], 20, 30, 3), # 11th century CE
			age_class.new([], [], [ 0, 1, 1, 3, 3, 4, 7, 9, 12, 10, 10, 11 ], 20, 30, 12), # 16th century CE
			age_class.new([12], [true], [ 0, 1, 1, 3, 4, 7, 9, 12, 12, 10, 11, 13, 14 ], 10, 15, null), # 20th century CE
			age_class.new([3, 0], [false, true], [ 0, 1, 3, 4, 7, 9, 12, 12, 10, 11, 13, 13, 14, 15 ], 20, 30, null) # 21st century CE
		];
	elif mode == 1: # protestant
		ages = [
			age_class.new([0], [true], [ 0, 0, 4, 5, 5, 5, 6, 6, 6, 7, 7, 8 ], 20, 30, 0), # 6th century BCE
			age_class.new([1], [true], [ 0, 0, 1, 4, 6, 6, 6, 6, 6, 7, 7, 8 ], 20, 30, 1), # 1st century CE
			age_class.new([0, 2], [false, true], [ 0, 1, 1, 1, 2, 4, 6, 7, 7, 7, 8, 9 ], 10, 15, null), # 5th century CE
			age_class.new([], [], [ 0, 1, 1, 1, 2, 4, 7, 7, 8, 9, 10, 11 ], 10, 15, 10), # 7th century CE
			age_class.new([2, 3], [false, true], [ 0, 1, 1, 2, 3, 4, 7, 8, 9, 10, 10, 11 ], 20, 30, 3), # 11th century CE
			age_class.new([1, 12, 2], [false, true, true], [ 0, 1, 1, 3, 3, 4, 7, 9, 12, 10, 10, 11 ], 20, 30, 12), # 16th century CE
			age_class.new([1], [true], [ 0, 1, 1, 3, 4, 7, 9, 12, 12, 10, 11, 13, 14 ], 10, 15, null), # 20th century CE
			age_class.new([3, 0], [false, true], [ 0, 1, 3, 4, 7, 9, 12, 12, 10, 11, 13, 13, 14, 15 ], 20, 30, null) # 21st century CE
		];
	elif mode == 2: # sunni
		ages = [
			age_class.new([0], [true], [ 0, 0, 4, 5, 5, 5, 6, 6, 6, 7, 7, 8 ], 20, 30, 0), # 6th century BCE
			age_class.new([1], [true], [ 0, 0, 1, 4, 6, 6, 6, 6, 6, 7, 7, 8 ], 20, 30, 1), # 1st century CE
			age_class.new([], [], [ 0, 1, 1, 1, 2, 4, 6, 7, 7, 7, 8, 9 ], 10, 15, null), # 5th century CE
			age_class.new([0, 1, 10], [false, false, true], [ 0, 1, 1, 1, 2, 4, 7, 7, 8, 9, 10, 11 ], 10, 15, 10), # 7th century CE
			age_class.new([0], [true], [ 0, 1, 1, 2, 3, 4, 7, 8, 9, 10, 10, 11 ], 20, 30, 3), # 11th century CE
			age_class.new([11], [true], [ 0, 1, 1, 3, 3, 4, 7, 9, 12, 10, 10, 11 ], 20, 30, 12), # 16th century CE
			age_class.new([0], [false], [ 0, 1, 1, 3, 4, 7, 9, 12, 12, 10, 11, 13, 14 ], 10, 15, null), # 20th century CE
			age_class.new([], [], [ 0, 1, 3, 4, 7, 9, 12, 12, 10, 11, 13, 13, 14, 15 ], 20, 30, null) # 21st century CE
		];

func start_game():
	age = next;
	if ages.size() > 0:
		next = ages.front();
		ages.remove(0);
	else:
		next = null;
	
	init_age(false);

func init_age(first):
	if first:
		for i in range(age.get_size()):
			add_dead(x - (list.size() + 1) * spacing, age.get_random_religion());
	if next != null:
		for i in range(next.get_size()):
			add_dead(x - (list.size() + 1) * spacing, next.get_random_religion());
	if age != null && age.has_religion_rule():
		display_rule(age.get_religion_rule(), age.get_rule());

func _input(input):
	var audio_move = get_node("audio_move");
	var audio_select = get_node("audio_select");
	
	if input.is_pressed():
		if screen == 1:
			var select = get_node("mode/select");
			if input.is_action("ui_left"):
				audio_move.play();
				mode -= 1;
				if mode < 0:
					select.translate(Vector2(20, 0));
					mode = 2;
				else:
					select.translate(Vector2(-10, 0));
			if input.is_action("ui_right"):
				audio_move.play();
				mode += 1;
				if mode > 2:
					select.translate(Vector2(-20, 0));
					mode = 0;
				else:
					select.translate(Vector2(10, 0));
		elif screen == 3 && get_node("choice").visible && (input.is_action("ui_left") || input.is_action("ui_right")):
			audio_move.play();
			choice = !choice;
			if choice:
				get_node("choice/select").translate(Vector2(10, 0));
			else:
				get_node("choice/select").translate(Vector2(-10, 0));
		if input.is_action("ui_accept"):
			if screen == 0:
				audio_select.play();
				get_node("spacebar").visible = false;
				get_node("mode").visible = true;
				screen = 1;
			elif screen == 1:
				audio_select.play();
				var yes = get_node("mode/yes");
				yes.translate(Vector2(mode * 10, 0));
				yes.visible = true;
				screen = 2;
				
				init_ages();
				next = ages.front();
				ages.remove(0);
				
				for instance in list:
					remove_child(instance);
				list.clear();
				init_age(false);
			elif screen == 3:
				var god = get_node("god");
				if god.visible:
					var religion = get_node("god/religion");
					var rule = get_node("god/rule");
					if religion.visible && rule.visible:
						god.visible = false;
						religion.visible = false;
						rule.visible = false;
						if age.has_religion_rule():
							display_rule(age.get_religion_rule(), age.get_rule());
						elif list.size() > 0:
							list[0].set_active(); # first up moves immediately
							list[0].connect("moved", self, "on_moved");
							for instance in list:
								instance.move(spacing);
					else:
						if !religion.visible:
							get_node("audio_god").play();
						religion.visible = true;
						rule.visible = true;
				elif has_message():
					# audio_select.play();
					remove_dead(choice);

func _process(delta):
	if screen <= 1:
		if randf() > 0.95:
			var instance = dead.instance();
			instance.translate(Vector2(randf() * 128, 52));
			instance.set_rotation_degrees(randf() * 360);
			instance.fall(100);
			add_child(instance);
			instance.connect("moved", self, "on_moved_remove");
	elif screen == 2:
		vspeed += delta * 2;
		var camera = get_node("camera");
		var d = min(vspeed, camera.position.y);
		camera.translate(Vector2(0, -d));
		if camera.position.y == 0:
			screen = 3;
			vspeed = 0;
			start_game();
	elif screen == 5:
		vspeed += delta * 2;
		var camera = get_node("camera");
		var d = min(vspeed, 75 - camera.position.y);
		camera.translate(Vector2(0, d));
		if camera.position.y == 75:
			seen.clear();
			allowed.clear();
			checked = 0;
			failures = 0;
			get_node("no1").texture = no_inactive;
			get_node("no2").texture = no_inactive;
			get_node("no3").texture = no_inactive;
			get_node("peter").visible = true;
			screen = 1;
			vspeed = 0;
	
	time += delta;
	if time > 0.5:
		if screen == 0:
			get_node("spacebar").modulate = Color(1, 1, 1, 0.66);
		elif screen == 3:
			time = 0;
			var god = get_node("god");
			if god.visible:
				var religion = get_node("god/religion");
				var rule = get_node("god/rule");
				if religion.visible:
					if !rule.visible:
						rule.visible = true;
				else:
					get_node("audio_god").play();
					religion.visible = true;
	if time > 1.0:
		time = 0;
		get_node("spacebar").modulate = Color(1, 1, 1, 1);

func display_rule(religion, rule):
	get_node("choice").visible = false;
	
	if rule:
		if allowed.find(rule) == -1:
			allowed.append(religion);
	else:
		allowed.erase(religion);
	
	get_node("god").visible = true;
	get_node("god/religion").texture = religions[religion];
	
	if rule:
		get_node("god/rule").texture = yes;
	else:
		get_node("god/rule").texture = no;
	
	time = 0;

func has_message():
	return list.size() > 0 && list[0].has_message();

func add_dead(x, religion):
	var instance = dead.instance();
	
	add_child(instance);
	list.append(instance);
	
	instance.set_religion(religion);
	instance.translate(Vector2(x, y));

func remove_dead(heaven):
	get_node("choice").visible = false;
	list[0].hide_message();
	if heaven:
		if list[0].get_religion() == 14:
			get_node("audio_aah").play();
		else:
			get_node("audio_yay").play();
		list[0].correct = allowed.find(list[0].get_religion()) != -1;
		list[0].move(56);
		list[0].connect("moved", self, "on_leave");
	else:
		if list[0].get_religion() == 14:
			get_node("audio_yay").play();
		else:
			get_node("audio_aah").play();
		list[0].correct = allowed.find(list[0].get_religion()) == -1;
		list[0].fall(32);
		list[0].connect("moved", self, "on_leave");
	list.remove(0);
	
	checked += 1;
	if age != null && checked >= age.get_size():
		checked = 0;
		age = next;
		if ages.size() > 0:
			next = ages.front();
			ages.remove(0);
		else:
			next = null;
		if age != null:
			init_age(false);
	
	if !get_node("god").visible && list.size() > 0:
		list[0].set_active(); # first up moves immediately
		list[0].connect("moved", self, "on_moved");
		for instance in list:
			instance.move(spacing);

func on_moved_remove(instance):
	remove_child(instance);

func on_moved(instance):
	if screen == 3 && list.size() > 0 && list[0] == instance:
		get_node("audio_human").play();
		get_node("choice").visible = true;
		instance.show_message();

func on_leave(instance):
	remove_child(instance);
	if screen == 3:
		if !instance.correct:
			if fail():
				game_over();
		elif age == null:
			var walking = 0;
			for child in get_children():
				if child is dead_class:
					walking += 1;
			if walking == 0:
				win();

func win():
	screen = 4;
	get_node("audio_yay").play();
	get_node("choice").visible = false;
	
	var peter = get_node("peter");
	peter.flip_h = true;
	peter.translate(Vector2(2, 0));
	peter.move(36);
	peter.connect("moved", self, "on_defeat");

func game_over():
	if list.size() > 0:
		list[0].hide_message();
	
	screen = 4;
	get_node("audio_aah").play();
	get_node("choice").visible = false;
	
	var peter = get_node("peter");
	peter.fall(96);
	peter.connect("moved", self, "on_defeat");

func on_defeat(peter):
	for instance in list:
		instance.move(-x - spacing);
	
	peter.visible = false;
	peter.reset();
	peter.set_position(Vector2(95, 52));
	peter.set_rotation(0);
	
	var yes = get_node("mode/yes");
	yes.translate(Vector2(mode * -10, 0));
	yes.visible = false;
	
	screen = 5;

func fail():
	get_node("audio_hell").play();
	if failures < 3:
		failures += 1;
		get_node("no" + str(failures)).texture = no;
	return failures == 3;
