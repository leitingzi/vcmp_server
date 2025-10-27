class SqoinContext {
	modules = null;
	singletons = null;
	factories = null;

	constructor() {
		this.modules = [];
		this.singletons = {};
		this.factories = {};
		log("Initialized dependency injection context");
	}

	function loadModule(module) {
		log("Loading module: " + module);
		this.modules.append(module);
		module.register(this);
		log("Module loaded successfully: " + module);
	}

	function registerSingleton(type, provider, params = {}) {
		log("Registering singleton dependency: " + type);
		this.singletons.rawset(type, {
			type = type,
			provider = provider,
			params = params,
			instance = null
		});
	}

	function registerFactory(type, provider, params = {}) {
		log("Registering factory dependency: " + type);
		this.factories.rawset(type, {
			type = type,
			provider = provider,
			params = params
		});
	}

	function get(type, args = {}) {
		log("Attempting to resolve dependency: " + type);

		if (this.singletons.rawin(type)) {
			log("Found singleton dependency: " + type);
			local singleton = this.singletons[type];
			if (singleton.instance == null) {
				singleton.instance = singleton.provider(this, args);
			}
			return singleton.instance;
		}

		if (this.factories.rawin(type)) {
			log("Found factory dependency: " + type);
			return this.factories[type].provider(this, args);
		}

		throw "No provider found for type: " + type;
	}

	function log(message) {
		print("[SqoinContext] " + message);
	}
}