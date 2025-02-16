import Fluent
import Vapor

struct MessageController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let messages = routes.grouped("chats", ":chatId", "messages")
        messages.post(use: create)
        messages.get(use: getAllMessages)
    }

    func create(req: Request) async throws -> Message {
        let messageData = try req.content.decode(CreateMessageRequest.self)

        guard let _ = try await Chat.find(messageData.chatId, on: req.db) else {
            throw Abort(.notFound, reason: "Chat not found")
        }

        let message = Message(content: messageData.content, createdAt: Date(), chatId: messageData.chatId)
        try await message.save(on: req.db)

        return message
    }

    func getAllMessages(req: Request) async throws -> [Message] {
        guard let chatId = req.parameters.get("chatId", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid chat id")
        }

        return try await Message.query(on: req.db)
            .filter(\.$chatId == chatId)
            .sort(\.$createdAt, .ascending)
            .all()
    }
}

// Структура для создания сообщения
struct CreateMessageRequest: Content {
    var chatId: UUID
    var content: String
}
