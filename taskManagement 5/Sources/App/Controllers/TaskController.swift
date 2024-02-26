//
//  File.swift
//  
//
//  Created by Alhanouf Abdullah Alatif  on 15/08/1445 AH.
//

import Foundation
import Fluent
import Vapor

struct TaskController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let tasks = routes.grouped("Task_1")
        tasks.get(use: index)
        tasks.post(use: create)
        tasks.group(":taskID") { tasks in
            tasks.delete(use: delete)
        }
        tasks.put(":taskID", use: update)
    }

    func index(req: Request) async throws -> [task] {
        try await task.query(on: req.db).all()
    }

 
    func create(req: Request) async throws -> task {
        do {
            let tasks = try req.content.decode(task.self)
            try await tasks.save(on: req.db)
            return tasks
        } catch {
            // Log the detailed error message
            req.logger.error("\(String(reflecting: error))")
            throw error // rethrow the error to be handled by Vapor's default error middleware
        }
    }

    
    func delete(req: Request) async throws -> HTTPStatus {
        guard let task = try await task.find(req.parameters.get("taskID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await task.delete(on: req.db)
        return .noContent
    }
    func update(req: Request) async throws -> task {
        guard let taskID = req.parameters.get("taskID", as: UUID.self),
              var taskItem = try await task.find(taskID, on: req.db) else {
            throw Abort(.notFound)
        }
        let input = try req.content.decode(task.self)
        taskItem.title = input.title
        taskItem.des = input.des
        taskItem.status = input.status
        taskItem.dueDate = input.dueDate
        taskItem.startDate = input.startDate
        try await taskItem.save(on: req.db)
        return taskItem
    }

}
