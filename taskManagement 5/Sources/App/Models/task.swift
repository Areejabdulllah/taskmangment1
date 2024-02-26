//
//  File.swift
//  
//
//  Created by aljawharah almasoud on 19/02/2024.
//

import Foundation
import Fluent
import Vapor

final class task: Model, Content{
    
    static let schema = "Task_1"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "des")
    var des: String
    
    @Field(key: "status")
    var status: String
    
    @Field(key: "dueDate")
    var dueDate: Date
    
    @Field(key: "startDate")
    var startDate: Date
    
    
    init(){}
    
    init(id: UUID? = nil, title: String, des: String, status: String, dueDate:Date, startDate: Date){
        self.id = id
        self.title = title
        self.des = des
        self.status = status
        self.dueDate = dueDate
        self.startDate = startDate
    }
}

