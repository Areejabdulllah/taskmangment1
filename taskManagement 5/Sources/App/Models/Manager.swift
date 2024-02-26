//
//  File.swift
//  
//
//  Created by Alhanouf Abdullah Alatif  on 15/08/1445 AH.
//

import Foundation
import Fluent
import Vapor

final class Manager: Model, Content {
    static let schema = "managers"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "employee_id") 
    var employee: employees
    
    @Parent(key: "task_id")
    var task: task
    
    init() {}
    
    init(id: UUID? = nil, employeeId: UUID, taskId: UUID) {
        self.id = id
        self.$employee.id = employeeId
        self.$task.id = taskId
    }
}
