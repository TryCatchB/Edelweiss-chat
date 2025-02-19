import Fluent
import Vapor

struct ChatController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let chats = routes.grouped("chats")
        chats.post(use: create)
        chats.get(use: getAll)
        chats.delete(":id", use: delete)
    }

    // Функция для создания чата
    func create(req: Request) async throws -> Chat {
        // Декодируем запрос и сохраняем объект чата
        let chat = try req.content.decode(Chat.self)
        try await chat.save(on: req.db)
        return chat
    }

    // Новый метод для получения всех чатов
    func getAll(req: Request) async throws -> [Chat] {
        // Просто возвращаем все чаты
        return try await Chat.query(on: req.db).all()
    }

    // Функция для удаления чата по id
func delete(req: Request) async throws -> HTTPStatus {
    // Получаем chatID из параметров
    guard let chatID = req.parameters.get("id", as: UUID.self) else {
        throw Abort(.badRequest, reason: "Invalid chat id")
    }

    // Находим чат в базе
    guard let chat = try await Chat.find(chatID, on: req.db) else {
        throw Abort(.notFound, reason: "Chat not found")
    }

    // Удаляем сначала все сообщения, связанные с чатом
    try await Message.query(on: req.db)
        .filter(\.$chatId == chatID) // Фильтруем сообщения по chatID
        .delete()

    // Теперь можно удалить сам чат
    try await chat.delete(on: req.db)

    return .noContent // Возвращаем 204 No Content
}
}
