import Fluent
import Vapor

struct ChatController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let chats = routes.grouped("chats")
        chats.post(use: create) // POST /chats
    }

    func create(req: Request) async throws -> Chat {
        let chat = try req.content.decode(Chat.self)
        try await chat.save(on: req.db)
        return chat
    }
}
