class SqoinContext {
	modules = null;
	singletons = null;
	factories = null;

	constructor() {
		this.modules = [];
		this.singletons = {};
		this.factories = {};
	}

	function loadModule(module) {
		print("SqoinContext loadModule" + module);
		this.modules.append(module);
		module.register(this);
	}

	function registerSingleton(type, provider) {
		print("registerSingleton: " + type);
		this.singletons.rawset(type, {
			type = type,
			provider = provider,
			instance = null
		});
	}

	function registerFactory(type, provider) {
		print("registerFactory: " + type);
		this.factories.rawset(type, {
			type = type,
			provider = provider
		});
	}

	function get(type) {
		print("SqoinContext get: " + type);

		if (this.singletons.rawin(type)) {
			print("singletons has: " + type);
			local singleton = this.singletons[type];
			if (singleton.instance == null) {
				singleton.instance = singleton.provider(this);
			}
			return singleton.instance;
		}

		if (this.factories.rawin(type)) {

			print("factories has: " + type);
			return this.factories[type].provider(this);
		}

		throw "No provider found for type: " + type;
	}
}