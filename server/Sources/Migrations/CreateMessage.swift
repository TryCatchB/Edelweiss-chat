import Fluent

struct CreateMessage: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("messages")
            .id()
            .field("content", .string, .required)
            .field("created_at", .datetime, .required)
            .field("chat_id", .uuid, .required, .references("chats", "id"))
            .create() 
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("messages").delete()
    }
}
