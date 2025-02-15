import Vapor

func routes(_ app: Application) throws {
    app.get(use: homeHandler)

    let controllers: [RouteCollection] = [
        ChatController(),
        MessageController(),
    ]

    try controllers.forEach { try app.register(collection: $0) }
}

func homeHandler(req: Request) -> String {
    "Привет!"
}
