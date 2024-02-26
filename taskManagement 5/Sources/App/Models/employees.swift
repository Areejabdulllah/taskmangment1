//
//  File.swift
//
//
//  Created by aljawharah almasoud on 19/02/2024.
//

import Foundation
import Fluent
import Vapor

final class employees: Model, Content{
    
    static let schema = "employees"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "role")
    var role: String
    
    
    init(){}
    
    init(id: UUID? = nil, name: String, email: String, password: String, role: String){
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.role = role
    }
}

