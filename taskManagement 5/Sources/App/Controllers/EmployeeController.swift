//
//  File.swift
//  
//
//  Created by Alhanouf Abdullah Alatif  on 15/08/1445 AH.
//

import Foundation
import Fluent
import Vapor


//EmployeeController
struct EmployeeController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let employe = routes.grouped("employees")
        employe.get(use: index)
        
        employe.post(use: create)
        employe.group(":employeeID") { employe in
            employe.delete(use: delete)
        }
        employe.put(":employeeID", use: update)
    }

    func index(req: Request) async throws -> [employees] {
        try await employees.query(on: req.db).all()
    }

  
    func create(req: Request) async throws -> employees {
        do {
            let employee = try req.content.decode(employees.self)
            try await employee.save(on: req.db)
            return employee
        } catch {
            // Log the detailed error message
            req.logger.error("\(String(reflecting: error))")
            throw error // rethrow the error to be handled by Vapor's default error middleware
        }
    }

    func get(req: Request) async throws -> employees {
        guard let employeeID = req.parameters.get("employeeID", as: UUID.self),
              let employee = try await employees.find(employeeID, on: req.db) else {
            throw Abort(.notFound, reason: "Employee not found.")
        }
        return employee
    }
    
    func delete(req: Request) async throws -> HTTPStatus {
        guard let employee = try await employees.find(req.parameters.get("employeeID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await employee.delete(on: req.db)
        return .noContent
    }
    func update(req: Request) async throws -> employees {
        guard let employeeID = req.parameters.get("employeeID", as: UUID.self),
              var employee = try await employees.find(employeeID, on: req.db) else {
            throw Abort(.notFound)
        }
        let input = try req.content.decode(employees.self)
        employee.name = input.name
        employee.email = input.email
        employee.password = input.password
        employee.role = input.role
        try await employee.save(on: req.db)
        return employee
    }

    
 

}
