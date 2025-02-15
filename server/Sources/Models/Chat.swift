import Fluent
import Vapor

final class Chat: Model, Content {
    static let schema = "chats" // Название таблицы чатов

    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Field(key: "created_at")
    var createdAt: Date

    init() { }

    init(id: UUID? = nil, title: String, createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
    }
}
