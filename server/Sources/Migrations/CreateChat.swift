import Fluent

struct CreateChat: AsyncMigration {
    func prepare(on database: Database) async throws {
        // Создание таблицы chats
        try await database.schema("chats")
            .id()
            .field("title", .string, .required)
            .field("created_at", .datetime)
            .create()
    }

    func revert(on database: Database) async throws {
        // Удаление таблицы chats
        try await database.schema("chats").delete()
    }
}
