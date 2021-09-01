//
//  File.swift
//  
//
//  Created by Ahmed Mgua on 01/09/2021.
//

import Fluent
import JWT
import Vapor

final class User: Model, Content	{
	
	static let schema = "Users"
	
	@ID(key: .id)
	var id: UUID?
	
	@Field(key: "UserName")
	var userName: String
	
	@Field(key: "Password")
	var password: String
	
	@Children(for: \.$user)
	var todos: [Todo]
	
	@Field(key: "CreatedBy")
	var createdBy: String?
	
	@Timestamp(key: "CreatedOn", on: .create)
	var createdOn: Date?
	
	@Field(key: "LastModifiedBy")
	var lastModifiedBy: String?
	
	@Timestamp(key: "LastModifiedOn", on: .update)
	var lastModifiedOn: Date?
	
	init()	{}
	init(id: UUID? = nil, userName: String, password: String)	{
		self.id = id
		self.userName = userName
		self.password = password
		self.createdBy = "app"
		self.lastModifiedBy = "app"
	}
}

extension User: ModelAuthenticatable	{
	static var usernameKey: KeyPath<User, Field<String>> {
		\.$userName
	}
	
	static var passwordHashKey: KeyPath<User, Field<String>> {
		\.$password
	}
	
	func verify(password: String) throws -> Bool {
		return try Bcrypt.verify(password, created: self.password)
	}
	
	
}

extension User	{
	func generateToken(_ app: Application) throws -> String	{
		var expDate = Date()
		expDate.addTimeInterval(86400 * 7)
		
		let exp = ExpirationClaim(value: expDate)
		
		return try app.jwt.signers.get(kid: .private)!.sign(MyJwtPayload(id: self.id, userName: self.userName, exp: exp))
	}
}
