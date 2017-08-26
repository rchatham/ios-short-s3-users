import MySQL
import LoggerAPI

// MARK: - UserMySQLDataAccessorProtocol

public protocol UserMySQLDataAccessorProtocol {
    func getUsers(withID id: String) throws -> [User]?
    func getUsers() throws -> [User]?
    func upsertStubUser(_ user: User) throws -> Bool
}

// MARK: - UserMySQLDataAccessor: UserMySQLDataAccessorProtocol

public class UserMySQLDataAccessor: UserMySQLDataAccessorProtocol {

    // MARK: Properties

    let pool: MySQLConnectionPoolProtocol

    // MARK: Initializer

    public init(pool: MySQLConnectionPoolProtocol) {
        self.pool = pool
    }

    // MARK: Queries

    public func getUsers(withID id: String) throws -> [User]? {
        let selectUser = MySQLQueryBuilder()
                .select(fields: ["id", "name", "location", "photo_url", "created_at", "updated_at"], table: "users")
                .wheres(statement: "Id=?", parameters: id)

        let result = try execute(builder: selectUser)
        let users = result.toUsers()
        return (users.count == 0) ? nil : users
    }

    public func getUsers() throws -> [User]? {
        let selectUsers = MySQLQueryBuilder()
                .select(fields: ["id", "name", "location", "photo_url", "created_at", "updated_at"], table: "users")

        let result = try execute(builder: selectUsers)
        let users = result.toUsers()
        return (users.count == 0) ? nil : users
    }

    // Upsert a stub user. If the user already exists, then nothing is updated and false is returned.
    public func upsertStubUser(_ user: User) throws -> Bool {
        let upsertUser = MySQLQueryBuilder()
                .upsert(data: user.toMySQLRow(), table: "users")

        Log.info("\(upsertUser.build())")
        let result = try execute(builder: upsertUser)
        Log.info("\(result.affectedRows)")
        return result.affectedRows > 0
    }

    // MARK: Utility

    func execute(builder: MySQLQueryBuilder) throws -> MySQLResultProtocol {
        let connection = try pool.getConnection()
        defer { pool.releaseConnection(connection!) }

        return try connection!.execute(builder: builder)
    }

    func execute(query: String) throws -> MySQLResultProtocol {
        let connection = try pool.getConnection()
        defer { pool.releaseConnection(connection!) }

        return try connection!.execute(query: query)
    }
}
