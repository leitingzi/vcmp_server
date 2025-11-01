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

function sqoinTest() {

	// Disable framework logging: Turn off log output by using Sqoin.enableLogger(false).
	Sqoin.enableLogger(false);

	// Define the user module userModule:
	local userModule = Module(function(module) {

		// Register Logger as a factory service with default parameters { id: 1 }
		module.factory("Logger", function(sqoin, args) {
			return Logger(args.id);
		}, function(sqoin) {
			return {
				id = 1
			}
		});

		// Register UserRepository as a singleton service, dependent on Logger.
		module.single("UserRepository", function(sqoin, args) {
			return UserRepository(sqoin.get("Logger"));
		});

		// Register UserService as a factory service, depending on UserRepository and Logger.
		module.factory("UserService", function(sqoin, args) {
			return UserService(args.repo, args.logger);
		}, function(sqoin) {
			return {
				repo = sqoin.get("UserRepository"),
				logger = sqoin.get("Logger")
			}
		});

		// Register the name as a singleton service, returning the fixed value "pq".
		module.single("name", function(sqoin, args) {
			return "pq";
		});
	});

	// Load module
	Sqoin.loadModule(userModule);

	// Obtain the default Logger (id=1) and the custom Logger (id=2), and verify the log output.
	local logger1 = Sqoin.get("Logger");
	local logger2 = Sqoin.get("Logger", function(sqoin) {
		return {
			id = 2
		}
	});

	// Get the name and print it (expected output: name: pq).
	local name = Sqoin.get("name");
	print("name: " + name);

	logger1.log(name);
	logger2.log(name);

	// Obtain the default UserService and the custom UserService (using Logger with id=2),
	// and call getUserInfo to verify the business process.
	local userService1 = Sqoin.get("UserService");
	local userService2 = Sqoin.get("UserService", function(sqoin) {
		return {
			repo = UserRepository(logger2),
			logger = logger2
		}
	});

	userService1.getUserInfo("userService1");
	userService2.getUserInfo("userService2");

	// After removing the userModule, attempt to get the registered service (name, UserService),
	// and an exception 'No provider found' is expected to be thrown.
	Sqoin.removeModule(userModule);

	try {
		local name = Sqoin.get("name");
		print(name);
	} catch (exception) {
		print("error: " + exception);
	}

	try {
		local userService1 = Sqoin.get("UserService");
		userService1.getUserInfo("userService1");
	} catch (exception) {
		print("error: " + exception);
	}
}

sqoinTest();