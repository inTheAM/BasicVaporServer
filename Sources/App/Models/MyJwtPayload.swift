//
//  File.swift
//  
//
//  Created by Ahmed Mgua on 01/09/2021.
//

import JWT
import Vapor

struct MyJwtPayload: Authenticatable, JWTPayload	{
	var id: UUID?
	var userName: String
	var exp: ExpirationClaim
	
	func verify(using signer: JWTSigner) throws {
		try self.exp.verifyNotExpired()
	}
}

