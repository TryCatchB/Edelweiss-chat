import Fluent
import Vapor

final class Message: Model, Content {
    static let schema = "messages"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "content")
    var content: String

    @Field(key: "createdAt")
    var createdAt: Date

    @Field(key: "chatId")
    var chatId: UUID

    @Field(key: "isUserMessage")
    var isUserMessage: Bool

    init() {}

    init(id: UUID? = nil, content: String, createdAt: Date, chatId: UUID, isUserMessage: Bool) {
        self.id = id
        self.content = content
        self.createdAt = createdAt
        self.chatId = chatId
        self.isUserMessage = isUserMessage
    }
}
