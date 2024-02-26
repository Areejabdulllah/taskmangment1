//
//  File.swift
//  
//
//  Created by Alhanouf Abdullah Alatif  on 15/08/1445 AH.
//

import Foundation
import Vapor
import Fluent

struct ManagerController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let managers = routes.grouped("managers")
        managers.post("assign_task", use: manualAssignTask)
        // GET route for `getEmployeeTasks`
        managers.get("employee-tasks", use: getEmployeeTasks)
    }

    
    // another solution
    // automatically assign tasks to employees
    
    // Manual assignment function
       func manualAssignTask(req: Request) async throws -> HTTPStatus {
           let assignment = try req.content.decode(TaskAssignment.self)
           
           // Create a new Manager record with the provided employeeId and taskId
           let newManager = Manager(employeeId: assignment.employeeId, taskId: assignment.taskId)
           try await newManager.save(on: req.db)
           
           return .ok
       }
    
     //Helper struct to decode request payload
     struct TaskAssignment: Content {
         var employeeId: UUID
         var taskId: UUID
     }
//
    func autoAssignTasks(req: Request) async throws -> HTTPStatus {
        // Retrieve all employees
        let allEmployees = try await employees.query(on: req.db).all()
        
        // Retrieve all tasks
        let allTasks = try await task.query(on: req.db).all()
        
        // Check if there are any employees or tasks to assign
        guard !allEmployees.isEmpty, !allTasks.isEmpty else {
            return .ok // Nothing to assign
        }
        
        //  Assign each task to a random employee
        for taskItem in allTasks {
            let randomEmployee = allEmployees.randomElement()!
            let newManager = Manager(employeeId: randomEmployee.id!, taskId: taskItem.id!)
            try await newManager.save(on: req.db)
        }
        
        // Return a success status
        return .ok
    }
  
    //struct that conforms to Content to hold the employee name and task title
    struct EmployeeTaskResponse: Content {
        let employeeName: String
        let taskTitle: String
    }
    
    //  getEmployeeTasks function to return an array of name of Employee and it's task
        func getEmployeeTasks(req: Request) async throws -> [EmployeeTaskResponse] {
            let employeeTasks = try await Manager.query(on: req.db)
                .join(employees.self, on: \Manager.$employee.$id == \employees.$id)
                .join(task.self, on: \Manager.$task.$id == \task.$id)
                .all()

            return try employeeTasks.map { manager -> EmployeeTaskResponse in
                let employee = try manager.joined(employees.self)
                let task = try manager.joined(task.self)
                return EmployeeTaskResponse(employeeName: employee.name, taskTitle: task.title)
            }
        }

}
