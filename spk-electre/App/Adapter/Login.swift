import Foundation
import FirebaseAuth

struct Login {
    func login(email: String, password: String) async throws {
        _ = try await Auth.auth().signIn(withEmail: email, password: password)
    }
}
