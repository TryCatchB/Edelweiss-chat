import Fluent
import Vapor

final class Chat: Model, Content {
    static let schema = "chats" // Имя таблицы в БД

    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    init() { }

    init(id: UUID? = nil, title: String) {
        self.id = id
        self.title = title
    }
}
