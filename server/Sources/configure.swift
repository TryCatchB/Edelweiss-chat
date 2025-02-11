import Vapor
import FluentPostgresDriver

// Эта функция вызывается при запуске приложения
public func configure(_ app: Application) throws {
    // Устанавливаем подключение к базе данных PostgreSQL
    app.databases.use(.postgres(
        hostname: "localhost",  // Адрес сервера PostgreSQL
        username: "postgres",   // Имя пользователя базы данных
        password: "0000",   // Пароль (укажи свой)
        database: "postgres"      // Имя базы данных
    ), as: .psql)
}
