import Vapor
import Fluent
import FluentPostgresDriver
import Configuration

public func configure(_ app: Application) throws {
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .DELETE, .OPTIONS],
        allowedHeaders: [.accept, .authorization, .contentType, .init("createdAt")],
        allowCredentials: true
    )
    app.middleware.use(CORSMiddleware(configuration: corsConfiguration))

    let config = ConfigurationManager()
    config.load(file: ".env")

    let hostname = config["DB_HOST"] as? String ?? "localhost"
    let port = Int(config["DB_PORT"] as? String ?? "5432") ?? 5432
    let username = config["DB_USER"] as? String ?? "postgres"
    let password = config["DB_PASSWORD"] as? String ?? "0000"
    let database = config["DB_NAME"] as? String ?? "edelweiss_chat"

    app.databases.use(.postgres(
        hostname: hostname,
        port: port,
        username: username,
        password: password,
        database: database
    ), as: .psql)

    app.migrations.add(CreateChat(), CreateMessage())
    try app.autoMigrate().wait()

    try routes(app)
}
