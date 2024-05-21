import FirebaseAuth
import Foundation

struct GetUser {
    static func user() -> User? {
        if let user = Auth.auth().currentUser,
           let name = user.displayName,
           let email = user.email {
            return .init(name: name, email: email, photoURL: user.photoURL)
        } else {
            return nil
        }
    }
}
