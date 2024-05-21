import Foundation

struct RegisterProvider {
    let doRegister: (
        _ email: String,
        _ password: String,
        _ name: String,
        _ photoURL: String?
    ) async throws -> Void

    func register(email: String, password: String, name: String, role: User.Role) async throws {
        try await doRegister(email, password, name, getPhotoURLFromRole(role))
    }
    
    private func getPhotoURLFromRole(_ role: User.Role) -> String? {
        switch role {
        case .admin:
            return "https://admin.com"
        case .visitor:
            return nil
        }
    }
}

extension RegisterProvider {
    static func make() -> RegisterProvider {
        .init(doRegister: Register.register)
    }
}
