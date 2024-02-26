import NIOSSL
import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(.postgres(hostname: "localhost", username: "postgres", password:"", database: "tasks"), as:.psql)

 
    app.migrations.add(CreateEmployee1())
    app.migrations.add(CreateTask98())
    app.migrations.add(CreateManager())

    try await app.autoMigrate()

    // register routes
    try routes(app)
}
