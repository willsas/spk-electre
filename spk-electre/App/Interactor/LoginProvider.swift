import Foundation

struct LoginProvider {
    
    enum Error: Swift.Error {
        case noUser
    }
    
    let getUser: () -> User?
    let doLogin: (_ email: String, _ password: String) async throws -> ()
    
    func login(email: String, password: String) async throws -> User {
        try await doLogin(email, password)
        guard let user = getUser() else { throw Error.noUser }
        return user
    }
}

extension LoginProvider {
    static func make() -> LoginProvider {
        .init(
            getUser: GetUser.user,
            doLogin: Login().login
        )
    }
}
