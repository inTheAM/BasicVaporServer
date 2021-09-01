import Fluent

struct CreateTodo: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("Todos")
            .id()
            .field("Title", .custom("character varying(100)"), .required)
			.field("Desc", .custom("character varying(200)"))
			.field("user_id", .uuid, .required, .references("Users", "id"))
			.field("CreatedBy", .custom("character varying(60)"), .required)
			.field("CreatedOn", .datetime, .required)
			.field("LastModifiedBy", .custom("character varying(60)"), .required)
			.field("LastModifiedOn", .datetime, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("Todos").delete()
    }
}
