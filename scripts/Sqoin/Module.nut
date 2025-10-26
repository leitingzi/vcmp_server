class Module {
	bindings = null;

	constructor(configure) {
		this.bindings = []
		if (configure != null) {
			configure(this);
		}
	}

	function single(type, provider) {
		// print("module single: " + type);
		this.bindings.append({
			type = "single",
			targetType = type,
			provider = provider
		});
	}

	function factory(type, provider) {
		// print("module factory: " + type);
		this.bindings.append({
			type = "factory",
			targetType = type,
			provider = provider
		});
	}

	function register(context) {
		// print("module register");
		foreach(binding in this.bindings) {
			if (binding.type == "single") {
				// print("single");
				context.registerSingleton(binding.targetType, binding.provider)
			} else if (binding.type == "factory") {
				// print("factory");
				context.registerFactory(binding.targetType, binding.provider)
			}
		}
	}
}