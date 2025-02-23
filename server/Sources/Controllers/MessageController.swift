import Fluent
import Vapor
import Configuration

struct MessageController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let messages = routes.grouped("chats", ":chatId", "messages")
        messages.post(use: create)
        messages.get(use: getAllMessages)
        messages.post("ai", use: sendMessageToAI)
    }

    func sendMessageToAI(req: Request) async throws -> Message {
        let requestData = try req.content.decode(CreateMessageRequest.self)

        guard let chat = try await Chat.find(requestData.chatId, on: req.db) else {
            throw Abort(.notFound, reason: "Чат не найден")
        }

        // Получаем историю чата из базы данных
        let messages = try await Message.query(on: req.db)
            .filter(\.$chatId == requestData.chatId)  // Здесь используется правильный фильтр
            .sort(\.$createdAt, .ascending)  // Используем правильное поле для сортировки
            .all()

        // Преобразуем историю сообщений в формат OpenAI
        var chatHistory: [[String: String]] = messages.map { msg in
            let role = msg.isUserMessage ? "user" : "assistant"
            return ["role": role, "content": msg.content]
        }
        
        // Добавляем текущее сообщение пользователя
        chatHistory.append(["role": "user", "content": requestData.content])

        // Отправляем запрос в OpenAI
        let openAIRequest = OpenAIRequest(model: "gpt-3.5-turbo", messages: chatHistory, max_tokens: 150)
        let aiResponse = try await callOpenAI(req: req, request: openAIRequest)

        // Сохраняем сообщение пользователя в базе данных
        let userMessage = Message(content: requestData.content, createdAt: Date(), chatId: requestData.chatId, isUserMessage: true)
        try await userMessage.save(on: req.db)

        // Сохраняем ответ AI в базе данных
        let aiMessage = Message(content: aiResponse, createdAt: Date(), chatId: requestData.chatId, isUserMessage: false)
        try await aiMessage.save(on: req.db)

        return aiMessage
    }

    func callOpenAI(req: Request, request: OpenAIRequest) async throws -> String {
        let config = ConfigurationManager()
        config.load(file: ".env")
        guard let apiKey = config["OPENAI_API_KEY"] as? String else {
            throw Abort(.internalServerError, reason: "API ключ не найден")
        }

        let openAIUrl = URI(string: "https://api.openai.com/v1/chat/completions")
        var headers = HTTPHeaders()
        headers.add(name: .authorization, value: "Bearer \(apiKey)")
        headers.add(name: .contentType, value: "application/json")

        let response = try await req.client.post(openAIUrl, headers: headers) { req in
            try req.content.encode(request)
        }

        guard response.status == .ok else {
            throw Abort(.internalServerError, reason: "Ошибка OpenAI: \(response.status)")
        }

        let openAIResponse = try response.content.decode(OpenAIResponse.self)
        return openAIResponse.choices.first?.message.content ?? "Ошибка в ответе OpenAI"
    }

    func create(req: Request) async throws -> Message {
        let messageData = try req.content.decode(CreateMessageRequest.self)

        guard let _ = try await Chat.find(messageData.chatId, on: req.db) else {
            throw Abort(.notFound, reason: "Chat not found")
        }

        let message = Message(content: messageData.content, createdAt: Date(), chatId: messageData.chatId, isUserMessage: true)
        try await message.save(on: req.db)

        return message
    }

    func getAllMessages(req: Request) async throws -> [Message] {
        guard let chatId = req.parameters.get("chatId", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid chat id")
        }

        return try await Message.query(on: req.db)
            .filter(\.$chatId == chatId)  // Здесь используется правильный фильтр
            .sort(\.$createdAt, .ascending)  // Используем правильное поле для сортировки
            .all()
    }
}

// Модели данных для работы с OpenAI API
struct OpenAIRequest: Content {
    var model: String
    var messages: [[String: String]]
    var max_tokens: Int
}

struct OpenAIResponse: Content {
    var choices: [Choice]
}

struct Choice: Content {
    var message: MessageContent
}

struct MessageContent: Content {
    var role: String
    var content: String
}

// Запрос на создание сообщения
struct CreateMessageRequest: Content {
    var chatId: UUID
    var content: String
}
