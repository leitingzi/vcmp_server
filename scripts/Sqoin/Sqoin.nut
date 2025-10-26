class Sqoin {
	static instance = SqoinContext();

	static function getInstance() {
		return Sqoin.instance;
	}

	static function loadModules(modules) {
		// print("Sqoin loadModules");
		foreach(module in modules) {
			Sqoin.getInstance().loadModule(module);
		}
	}

	static function get(type) {
		return Sqoin.getInstance().get(type);
	}
}