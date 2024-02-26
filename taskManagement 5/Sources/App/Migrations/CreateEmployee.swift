//
//  File.swift
//  
//
//  Created by Alhanouf Abdullah Alatif  on 15/08/1445 AH.
//

import Foundation
import Fluent
import FluentPostgresDriver


struct CreateEmployee1: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void>{
        database.schema("employees")
            .id()
            .field("name", .string)
            .field("email", .string)
            .field("password", .string)
            .field("role", .string)
            .create()
        
    }
    
    
    func revert(on database: Database) -> EventLoopFuture<Void>{
        database.schema("employees").delete()
    }
    
}
