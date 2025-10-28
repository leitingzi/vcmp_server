class Logger {
	id = null;
	constructor(id) {
		this.id = id;
	}
	function log(message) {
		print("Log" + id + ": " + message);
	}
}

class UserRepository {
	logger = null;

	constructor(logger) {
		this.logger = logger;
	}

	function getUser(id) {
		this.logger.log("Getting user with id: " + id);
		return {
			id = id,
			name = "User " + id
		};
	}
}

class UserService {
	repo = null;
	logger = null;

	constructor(repo, logger) {
		this.repo = repo;
		this.logger = logger;
	}

	function getUserInfo(id) {
		this.logger.log("Fetching user info");
		return this.repo.getUser(id);
	}
}

Sqoin.enableLogger(false);

local userModule = Module(function(module) {
	module.factory("Logger", function(sqoin, args) {
		return Logger(args.id);
	}, {
		id = 1
	});

	module.single("UserRepository", function(sqoin, args) {
		return UserRepository(sqoin.get("Logger"));
	});

	module.factory("UserService", function(sqoin, args) {
		return UserService(sqoin.get("UserRepository"), args.logger);
	}, {
		logger = sqoin.get("Logger")
	});

	module.single("name", function(sqoin, args) {
		return "pq";
	});
});

local modules = [userModule];

Sqoin.loadModules(modules);

local logger1 = Sqoin.get("Logger");
local logger2 = Sqoin.get("Logger", {
	id = 2
});

local userService1 = Sqoin.get("UserService");
local userService2 = Sqoin.get("UserService", {
	logger = logger2
});

userService1.getUserInfo(123);
userService2.getUserInfo(456);

local name = Sqoin.get("name");
print(name);

Sqoin.removeModule(userModule);

try {
	local name = Sqoin.get("name");
	print(name);
} catch (exception) {
	print(exception);
}