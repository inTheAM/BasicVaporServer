//
//  File.swift
//  
//
//  Created by Ahmed Mgua on 01/09/2021.
//

import JWT
import Vapor

struct JWTBearerAuthenticator: JWTAuthenticator	{	
	func authenticate(jwt: MyJwtPayload, for request: Request) -> EventLoopFuture<Void> {
		do {
			try jwt.verify(using: request.application.jwt.signers.get()!)
			return User
				.find(jwt.id, on: request.db)
				.unwrap(or: Abort(.notFound))
				.map { user in
					request.auth.login(user)
				}
		} catch	{
			return request.eventLoop.makeSucceededVoidFuture()
		}
	}
}
