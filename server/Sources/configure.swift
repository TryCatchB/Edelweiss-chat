import Vapor
import Fluent
import FluentPostgresDriver

public func configure(_ app: Application) async throws {
    // Настроим подключение к базе данных PostgreSQL
    app.databases.use(
        .postgres(
            hostname: "localhost",  // Адрес сервера PostgreSQL
            port: 5432,             // Порт
            username: "postgres",   // Имя пользователя базы данных
            password: "0000",       // Пароль
            database: "postgres"   // Имя базы данных
        ),
        as: .psql
    )
    
    // Регистрация миграций
    app.migrations.add(CreateChat())

    // Применение миграций
    try await app.autoMigrate()
    
    // Регистрация контроллеров
    try app.register(collection: ChatController())
}
