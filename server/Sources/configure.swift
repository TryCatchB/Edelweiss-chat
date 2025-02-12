import Vapor
import Fluent
import FluentPostgresDriver


public func configure(_ app: Application) throws {
    // Настроим подключение к базе данных PostgreSQL с учетом последних версий
    app.databases.use(.postgres(
        configuration: SQLPostgresConfiguration(
            hostname: "localhost",  // Адрес сервера PostgreSQL
            port: 5432, // Порт
            username: "postgres",   // Имя пользователя базы данных
            password: "0000",       // Пароль
            database: "postgres",    // Имя базы данных
            tls: .prefer(try .init(configuration: .clientDefault))
        )
    ), as: .psql) // Подключаем как PostgreSQL
}
