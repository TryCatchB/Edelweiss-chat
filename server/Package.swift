// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "server",
    platforms: [
        .macOS(.v10_15)
    ],
    dependencies: [
        // Зависимости проекта
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "4.0.0"),
    ],
    targets: [
        // Основной target для запуска сервера
        .executableTarget(
            name: "server",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver")
            ]
        ),
    ]
)
