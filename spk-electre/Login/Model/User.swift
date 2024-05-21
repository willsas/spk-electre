import Foundation

struct User {
    let name: String
    let email: String
    let photoURL: URL?

    enum Role {
        case admin
        case visitor
    }
}

extension User {
    var role: Role { photoURL?.absoluteString.contains("admin") == true ? .admin : .visitor }
}
