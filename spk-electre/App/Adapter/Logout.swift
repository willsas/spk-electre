import Foundation
import FirebaseAuth

struct Logout {
    static func logout() throws -> Void {
        try Auth.auth().signOut()
    }
}
