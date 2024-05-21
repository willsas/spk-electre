import Foundation

@MainActor
final class LoginViewModel {
    
    typealias Login = (
        _ email: String,
        _ password: String
    ) async throws -> User
    
    var showError: ((String) -> Void)?
    var successLogin: (() -> Void)?
    
    var email: String = ""
    var password: String = ""
    
    private let login: Login
    
    init(login: @escaping Login) {
        self.login = login
    }
    
    func loginUser() async {
        guard email.isNotEmpty, password.isNotEmpty
        else {
            showError?("Some fields are empty!")
            return
        }
        
        do {
            _ = try await login(email, password)
            successLogin?()
        } catch {
            showError?("Failed to login: \(error.localizedDescription)")
        }
    }
}

extension LoginViewModel {
    static func make() -> LoginViewModel {
        .init(login: LoginProvider.make().login)
    }
}
