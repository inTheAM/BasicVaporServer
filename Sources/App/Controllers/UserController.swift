//
//  File.swift
//  
//
//  Created by Ahmed Mgua on 01/09/2021.
//

import Fluent
import Vapor

struct UserController: RouteCollection	{
	func boot(routes: RoutesBuilder) throws {
		let users = routes.grouped("users")
		users.post(use: create)
		users.group(":userName")	{ user in
			user.get(use: get)
		}
		
		users.group("login")	{	user in
			user.post(use: login)
		}
		
		users.grouped(JWTBearerAuthenticator())
			.group("me") { user in
				user.get(use: returnCurrentUser)
			}
	}
	
	
	func get(req: Request) throws -> EventLoopFuture<User>	{
		return User.query(on: req.db)
			.filter(\.$userName == req.parameters.get("userName") ?? "NA")
			.first()
			.unwrap(or: Abort(.notFound))
	}
	
	func create(req: Request) throws -> EventLoopFuture<User>	{
		let user = try req.content.decode(User.self)
		
		return user.create(on: req.db).map { user }
	}
	
	func login(req: Request) throws -> EventLoopFuture<String>	{
		let userToLogin = try req.content.decode(UserLogin.self)
		
		return User.query(on: req.db)
			.filter(\.$userName == userToLogin.userName)
			.first()
			.unwrap(or: Abort(.notFound))
			.flatMapThrowing { dbUser in
				let verified = try dbUser.verify(password: userToLogin.password)
				
				if verified  	{
					req.auth.login(dbUser)
					let user = try req.auth.require(User.self)
					return try user.generateToken(req.application)
				} else	{
					throw Abort(.unauthorized)
				}
			}
	}
	
	func returnCurrentUser(req: Request)	throws -> EventLoopFuture<CurrentUser>	{
		let user = try req.auth.require(User.self)
		let userName = user.userName
		
		return User.query(on: req.db)
			.filter(\.$userName == userName)
			.first()
			.unwrap(or: Abort(.notFound))
			.map { usr in
				return CurrentUser(id: UUID(), userName: usr.userName)
			}
	}
}
