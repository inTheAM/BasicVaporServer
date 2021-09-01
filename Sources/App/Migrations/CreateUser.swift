//
//  File.swift
//  
//
//  Created by Ahmed Mgua on 01/09/2021.
//

import Fluent
import SQLKit
import Vapor

struct CreateUser: Migration	{
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		return database.schema("Users")
			.id()
			.field("UserName", .custom("character varying(60)"), .required)
			.field("Password", .custom("character varying(60)"), .required)
			.field("CreatedBy", .custom("character varying(60)"), .required)
			.field("CreatedOn", .datetime, .required)
			.field("LastModifiedBy", .custom("character varying(60)"), .required)
			.field("LastModifiedOn", .datetime, .required)
			.unique(on: "UserName")
			.create()
	}
	
	func revert(on database: Database) -> EventLoopFuture<Void> {
		return database.schema("Users").delete()
	}
}
