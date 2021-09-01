//
//  File.swift
//  
//
//  Created by Ahmed Mgua on 01/09/2021.
//

import Vapor

//simple struct to return details of current user querying db
struct CurrentUser: Content	{
	var id: UUID?
	var userName: String
}
