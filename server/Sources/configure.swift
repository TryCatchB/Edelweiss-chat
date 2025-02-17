import Vapor
import Fluent
import FluentPostgresDriver

public func configure(_ app: Application) throws {
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,              // Разрешены все источники
        allowedMethods: [.GET, .POST, .PUT, .DELETE, .OPTIONS], // Разрешены методы
        allowedHeaders: [.accept, .authorization, .contentType, .init("createdAt")], // Разрешаем добавленный заголовок
        allowCredentials: true               // Разрешить работу с cookie
    )
    app.middleware.use(CORSMiddleware(configuration: corsConfiguration))

    app.databases.use(.postgres(
        hostname: "localhost",
        port: 5432,
        username: "postgres",
        password: "0000",
        database: "edelweiss_chat"
    ), as: .psql)

    // Добавляем миграции
    app.migrations.add(CreateChat(), CreateMessage())
    try app.autoMigrate().wait()

    try routes(app)
}
