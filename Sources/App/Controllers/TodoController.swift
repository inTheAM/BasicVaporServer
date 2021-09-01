import Fluent
import Vapor

struct TodoController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let todos = routes.grouped("todos")
			.grouped(JWTBearerAuthenticator())
        todos.get(use: index)
        todos.post(use: create)
        todos.group(":todoID") { todo in
            todo.delete(use: delete)
        }
		
    }

    func index(req: Request) throws -> EventLoopFuture<[Todo]> {
		let user = try req.auth.require(User.self)
		return Todo.query(on: req.db)
			.filter(\.$user.$id == user.id!)
			.all()
    }

    func create(req: Request) throws -> EventLoopFuture<Todo> {
//        let todo = try req.content.decode(Todo.self)
//        return todo.save(on: req.db).map { todo }
		let user = try req.auth.require(User.self)
		let dto = try req.content.decode(TodoDto.self)
		return User.query(on: req.db)
			.filter(\.$userName == user.userName)
			.first()
			.unwrap(or: Abort(.notFound))
			.flatMap { usr  in
				let todo = Todo(title: dto.title, desc: dto.desc, user: usr)
				return todo.create(on: req.db).map {
					todo
				}
			}
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Todo.find(req.parameters.get("todoID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
