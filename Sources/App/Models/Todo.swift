import Fluent
import Vapor

final class Todo: Model, Content {
    static let schema = "Todos"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "Title")
    var title: String

	@OptionalField(key: "Desc")
	var desc: String?
	
	@Parent(key: "user_id")
	var user: User
	
	@OptionalField(key: "CreatedBy")
	var createdBy: String?
	
	@Timestamp(key: "CreatedOn", on: .create)
	var createdOn: Date?
	
	@OptionalField(key: "LastModifiedBy")
	var lastModifiedBy: String?
	
	@Timestamp(key: "LastModifiedOn", on: .update)
	var lastModifiedOn: Date?
	
	
    init() { }

	init(id: UUID? = nil, title: String, desc: String?, user: User) {
        self.id = id
        self.title = title
		self.desc = desc
		self.$user.id = user.id! //only ID needed to create relationship
		self.createdBy = "app"
		self.lastModifiedBy = "app"
    }
}
