import FirebaseAuth
import Foundation

struct Register {
    static func register(
        email: String,
        password: String,
        name: String,
        photoURL: String?
    ) async throws {
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        let changeRequest = authResult.user.createProfileChangeRequest()
        changeRequest.displayName = name
        if let photoURL { changeRequest.photoURL = URL(string: photoURL) }
        try await changeRequest.commitChanges()
    }
}
