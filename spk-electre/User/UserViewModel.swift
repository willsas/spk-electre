import Foundation

final class UserViewModel {
    
    struct UserParam {
        let name: String
        let email: String
        let role: String
    }
    
    var onUserUpdate: ((UserParam) -> Void)?
    var onLogoutSucceed: (() -> Void)?
    var onError: ((String) -> Void)?
    
    private let getUser: () -> User?
    private let logout: () throws -> Void
    
    init(getUser: @escaping () -> User?, logout: @escaping () throws -> Void) {
        self.getUser = getUser
        self.logout = logout
    }
    
    func loadUser() {
        guard let user = getUser() else { return }
        onUserUpdate?(UserParam(name: user.name, email: user.email, role: user.role.displayedRole))
    }
    
    func doLogout() {
        do {
            try logout()
            onLogoutSucceed?()
        } catch {
            onError?(error.localizedDescription)
        }
    }
}

private extension User.Role {
    var displayedRole: String {
        switch self {
        case .admin:
            return "admin"
        case .visitor:
            return "visitor"
        }
    }
}

extension UserViewModel {
    static func make() -> UserViewModel {
        .init(getUser: GetUser.user, logout: Logout.logout)
    }
}
