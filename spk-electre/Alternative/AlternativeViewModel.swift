import Foundation

@MainActor
final class AlternativeViewModel {

    var onUploadSuccees: (() -> Void)?
    var onErorr: ((String) -> Void)?
    var onShowLoading: ((Bool) -> Void)?
    var onSavedFileName: ((String?) -> Void)?
    var onShowDocument: ((URL) -> Void)?
    var onUploadEnabled: ((Bool) -> Void)?

    private let getAlternative: () async throws -> URL
    private let getTemplateAlternative: () async throws -> URL
    private let sendAlternative: (URL) async throws -> Void
    private let currentUser: () -> User?

    init(
        getAlternative: @escaping () async throws -> URL,
        getTemplateAlternative: @escaping () async throws -> URL,
        sendAlternative: @escaping (URL) async throws -> Void,
        currentUser: @escaping () -> User?
    ) {
        self.getAlternative = getAlternative
        self.getTemplateAlternative = getTemplateAlternative
        self.sendAlternative = sendAlternative
        self.currentUser = currentUser
    }
    
    func checkUploadCapability() {
        guard let user = currentUser() else {
            onUploadEnabled?(false)
            return
        }
        onUploadEnabled?(user.role == .admin)
    }
    
    func getAlternative() async {
        onShowLoading?(true)
        do {
            let localPathURL = try await getAlternative()
            onShowLoading?(false)
            onSavedFileName?(localPathURL.fileName)
        } catch {
            onShowLoading?(false)
            onSavedFileName?(nil)
        }
    }

    func upload(_ url: URL) async {
        onShowLoading?(true)
        do {
            try await sendAlternative(url)

            onShowLoading?(false)
            onUploadSuccees?()
        } catch {
            onShowLoading?(false)
            onErorr?(error.localizedDescription)
        }
    }
    
    func showAlternative() async {
        onShowLoading?(true)
        do {
            let localPathURL = try await getAlternative()
            onShowLoading?(false)
            onShowDocument?(localPathURL)
        } catch {
            onShowLoading?(false)
            onSavedFileName?(nil)
        }
    }

    func showTemplate() async {
        onShowLoading?(true)
        do {
            let localFilePath = try await getTemplateAlternative()
            onShowLoading?(false)
            onShowDocument?(localFilePath)
        } catch {
            onShowLoading?(false)
            onErorr?(error.localizedDescription)
        }
    }
}

extension AlternativeViewModel {
    static func make() -> AlternativeViewModel {
        let getAlternative = GetAlternativePath.make()
        let postAlternative = PostAlternative.make()
        return AlternativeViewModel(
            getAlternative: getAlternative.current,
            getTemplateAlternative: getAlternative.template,
            sendAlternative: postAlternative.postAndSave,
            currentUser: GetUser.user
        )
    }
}
