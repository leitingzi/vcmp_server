class Sqoin {
	static instance = SqoinContext();

	static function getInstance() {
		return Sqoin.instance;
	}

	static function loadModules(modules) {
		foreach(module in modules) {
			Sqoin.getInstance().loadModule(module);
		}
	}

	static function removeModule(module) {
		Sqoin.getInstance().removeModule(module);
	}

	static function get(type, args = null) {
		return Sqoin.getInstance().get(type, args);
	}
}