import Fluent
import Vapor

struct MessageController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        // Группировка маршрутов для сообщений
        let messages = routes.grouped("chats", ":chatId", "messages")
        messages.post(use: create)  // Создание сообщения
        messages.get(use: getAllMessages) // Получение всех сообщений
    }

    // Функция для создания сообщения в чате
    func create(req: Request) async throws -> Message {
        let messageData = try req.content.decode(CreateMessageRequest.self)
        
        // Проверяем, существует ли чат с таким chatId
        guard let _ = try await Chat.find(messageData.chatId, on: req.db) else {
            throw Abort(.notFound, reason: "Chat not found")
        }

        // Создаем и сохраняем новое сообщение
        let message = Message(content: messageData.content, chatId: messageData.chatId)
        try await message.save(on: req.db)

        return message
    }

    // Функция для получения всех сообщений из чата
    func getAllMessages(req: Request) async throws -> [Message] {
        // Извлекаем chatId из параметров запроса
        guard let chatId = req.parameters.get("chatId", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid chat id")
        }

        // Получаем все сообщения для этого чата
        return try await Message.query(on: req.db)
            .filter(\.$chatId == chatId)
            .all()
    }
}

// Структура для создания сообщения
struct CreateMessageRequest: Content {
    var chatId: UUID
    var content: String
}
