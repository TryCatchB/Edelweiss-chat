import Vapor
import Fluent
import FluentPostgresDriver

public func configure(_ app: Application) throws {
    app.databases.use(.postgres(
        hostname: "localhost",
        port: 5432,
        username: "postgres",
        password: "0000",
        database: "edelweiss_chat"
    ), as: .psql)

    app.migrations.add(CreateChat(), CreateMessage())
    try app.autoMigrate().wait()

    try routes(app)
}
