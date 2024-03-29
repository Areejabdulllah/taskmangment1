import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    try app.register(collection: EmployeeController())
    try app.register(collection: TaskController())
    try app.register(collection: ManagerController())

}
