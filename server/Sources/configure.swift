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

    // Добавляем CORS Middleware
    let corsConfig = CORSMiddleware(configuration: .init(
        allowedOrigin: .custom("http://localhost:3000"), // Разрешаем запросы с фронтенда
        allowedMethods: [.GET, .POST, .PUT, .DELETE, .OPTIONS], // Разрешённые HTTP-методы
        allowedHeaders: [.accept, .contentType, .origin, .authorization]
    ))
    app.middleware.use(corsConfig)

    // Добавляем миграции
    app.migrations.add(CreateChat(), CreateMessage())
    try app.autoMigrate().wait()

    try routes(app)
}
