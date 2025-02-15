import Vapor

let app = Application(.development)
defer { app.shutdown() }

do {
    try configure(app)
    try app.run()
} catch {
    app.logger.report(error: error)
    fatalError("Ошибка запуска: \(error)")
}
