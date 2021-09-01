//
//  File.swift
//  
//
//  Created by Ahmed Mgua on 01/09/2021.
//

import Foundation

extension String	{
	var bytes: [UInt8] {
		.init(self.utf8)
	}
}
