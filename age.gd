var _rule_religion = [];
var _rule_yesno = [];
var _religions = [];
var _size = 0;

var _first = true;
var _first_religion = null;

func _init(rule_religion, rule_yesno, religions, lower, upper, first):
	self._rule_religion = rule_religion;
	self._rule_yesno = rule_yesno;
	self._religions = religions;
	self._size = int(rand_range(lower, upper));
	self._first_religion = first;

func get_size():
	return _size;

func has_religion_rule():
	return _rule_religion.size() > 0;

func get_religion_rule():
	var r = _rule_religion[0];
	_rule_religion.remove(0);
	return r;

func get_rule():
	var r = _rule_yesno[0];
	_rule_yesno.remove(0);
	return r;

func get_random_religion():
	if _first_religion != null && _first:
		_first = false;
		return _first_religion;
	var r = _religions[randi() % _religions.size()];
	if r > 13 && randf() > 0.5:
		r = _religions[randi() % _religions.size()];
	return r;
