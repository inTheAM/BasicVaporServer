import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> EventLoopFuture<String> in
		let promise = req.eventLoop.makePromise(of: String.self)
		
		let msg: String = try req.query.get(at: "msg")
		promise.succeed("\(msg)")
		
		return promise.futureResult
    }
	app.get("john")	{ req -> EventLoopFuture<Response> in
		let user = User(userName: "john", password: "password")
		return user.create(on: req.db).map    {
			return req.redirect(to: "/")
		}
	}
	app.get("hello", ":msg") { req -> EventLoopFuture<String> in
		let promise = req.eventLoop.makePromise(of: String.self)
		
		let msg = req.parameters.get("msg")
		promise.succeed("\(msg ?? "")")
		
		return promise.futureResult
	}
	
	app.post("hello") { req -> EventLoopFuture<String> in
		let dto = try req.content.decode(TodoDto.self)
		let promise = req.eventLoop.makePromise(of: String.self)
		
		print("dto: ", dto)
		
		return promise.futureResult
	}
	
	
	try app.register(collection: UserController())
    try app.register(collection: TodoController())
}
