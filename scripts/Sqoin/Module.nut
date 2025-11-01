class Module {
	bindings = null;

	constructor(configure) {
		this.bindings = [];
		if (configure != null) {
			configure(this);
		}
	}

	function single(type, provider, params = @(sqoin) {}) {
		this.bindings.append({
			type = "single",
			targetType = type,
			provider = provider,
			params = params
		});
	}

	function factory(type, provider, params = @(sqoin) {}) {
		this.bindings.append({
			type = "factory",
			targetType = type,
			provider = provider,
			params = params
		});
	}

	function register(context) {
		foreach(binding in this.bindings) {
			if (binding.type == "single") {
				context.registerSingleton(binding.targetType, binding.provider, binding.params);
			} else if (binding.type == "factory") {
				context.registerFactory(binding.targetType, binding.provider, binding.params);
			}
		}
	}

	function getBindingTypes() {
		local types = [];
		foreach(binding in this.bindings) {
			types.append(binding.targetType);
		}
		return types;
	}
}