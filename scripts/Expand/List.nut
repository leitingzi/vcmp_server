class List {
	entity = null;

	constructor(...) {
		entity = [];
		for (local i = 0; i < vargv.len(); i++) {
			entity.append(vargv[i]);
		}
	}

	function _typeof() {
		return "list";
	}

	static function create(size, f) {
		entity = [];
		for (local i = 0; i < size; i++) {
			entity.append(f(i));
		}
		return this;
	}
}