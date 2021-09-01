import Fluent
import FluentPostgresDriver
import Vapor
import JWT

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapordb"
    ), as: .psql)

//	migrations
	app.migrations.add(CreateUser())
    app.migrations.add(CreateTodo())

//	JWT
	let privateKey = try String(contentsOfFile: app.directory.workingDirectory + "myjwt.key")
	let privateSigner = try JWTSigner.rs256(key: .private(pem: privateKey.bytes))
	
	let publicKey = try String(contentsOfFile: app.directory.workingDirectory + "myjwt.key.pub")
	let publicSigner = try JWTSigner.rs256(key: .public(pem: publicKey.bytes))
	
	app.jwt.signers.use(privateSigner, kid: .private)
	app.jwt.signers.use(publicSigner, kid: .public, isDefault: true)
	
	
    // register routes
    try routes(app)
}
