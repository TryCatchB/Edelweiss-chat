import Fluent
import Vapor

final class Message: Model, Content {
    static let schema = "messages"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "content")
    var content: String

    @Field(key: "created_at")
    var createdAt: Date

    @Field(key: "chat_id")
    var chatId: UUID

    init() { }

    init(id: UUID? = nil, content: String, createdAt: Date = Date(), chatId: UUID) {
        self.id = id
        self.content = content
        self.createdAt = createdAt
        self.chatId = chatId
    }
}
