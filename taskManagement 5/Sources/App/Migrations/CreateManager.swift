//
//  File.swift
//  
//
//  Created by Alhanouf Abdullah Alatif  on 15/08/1445 AH.
//

import Foundation
import Fluent
import FluentPostgresDriver

struct CreateManager: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("managers")
            .id()
            .field("employee_id", .uuid, .required, .references("employees", "id", onDelete: .cascade))
            .field("task_id", .uuid, .required, .references("Task_1", "id", onDelete: .cascade))
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("managers").delete()
    }
}
