// The Swift Programming Language
// https://docs.swift.org/swift-book

import Vapor

// Создание экземпляра приложения
let app = Application(.development)

// Настроим несколько маршрутов
app.get { req in
    return "Привет Котуня!"
}

// Запуск приложения
try app.run()
