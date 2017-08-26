import Foundation
import SwiftyJSON
import LoggerAPI

// MARK: - User

public struct User {
    public var id: Int?
    public var name: String?
    public var location: String?
    public var photoURL: String?
    public var createdAt: Date?
    public var updatedAt: Date?
}

// MARK: - User: JSONAble

extension User: JSONAble {
    public func toJSON() -> JSON {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        var dict = [String: Any]()
        let nilValue: Any? = nil

        dict["id"] = id != nil ? id : nilValue
        dict["name"] = name != nil ? name : nilValue
        dict["location"] = location != nil ? location : nilValue
        dict["photoURL"] = photoURL != nil ? photoURL : nilValue

        dict["created_at"] = createdAt != nil ? dateFormatter.string(from: createdAt!) : nilValue
        dict["updated_at"] = updatedAt != nil ? dateFormatter.string(from: updatedAt!) : nilValue

        return JSON(dict)
    }
}

// MARK: - User (MySQLRow)

extension User {
    func toMySQLRow() -> ([String: Any]) {
        var data = [String: Any]()

        // If a value is nil, then it won't be added to the dictionary
        data["id"] = id
        data["name"] = name
        data["location"] = location
        data["photoURL"] = photoURL

        return data
    }
}
