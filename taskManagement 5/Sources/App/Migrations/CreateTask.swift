//
//  File.swift
//  
//
//  Created by aljawharah almasoud on 20/02/2024.
//

import Foundation
import Fluent
import FluentPostgresDriver


struct CreateTask98: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("Task_1")
            .id()
            .field("title", .string)
            .field("des", .string)
            .field("status", .string)
            .field("dueDate", .datetime)
            .field("startDate", .datetime) 
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("Task_1").delete()
    }
}
