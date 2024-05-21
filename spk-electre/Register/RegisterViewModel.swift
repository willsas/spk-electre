import Foundation

@MainActor
final class RegisterViewModel {

    typealias Register = (
        _ email: String,
        _ password: String,
        _ name: String,
        _ role: User.Role
    ) async throws -> Void

    var showError: ((String) -> Void)?
    var successRegister: (() -> Void)?

    var name: String = ""
    var email: String = ""
    var password: String = ""
    var role: String = ""

    private let register: Register

    init(register: @escaping Register) {
        self.register = register
    }

    func registerUser() async {
        guard name.isNotEmpty, email.isNotEmpty, password.isNotEmpty,
              role.isNotEmpty, let role = User.Role(from: role)
        else {
            showError?("Some fields are empty!")
            return
        }

        do {
            try await register(email, password, name, role)
            successRegister?()
        } catch {
            showError?("Failed to register: \(error.localizedDescription)")
        }
    }
}

private extension User.Role {
    init?(from value: String) {
        switch value.lowercased() {
        case "admin":
            self = .admin
        case "visitor":
            self = .visitor
        default: return nil
        }
    }
}

extension RegisterViewModel {
    static func make() -> RegisterViewModel {
        .init(register: RegisterProvider.make().register)
    }
}
