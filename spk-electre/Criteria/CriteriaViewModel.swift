import Foundation

@MainActor
final class CriteriaViewModel {

    var onUploadSuccees: (() -> Void)?
    var onErorr: ((String) -> Void)?
    var onShowLoading: ((Bool) -> Void)?
    var onSavedFileName: ((String?) -> Void)?
    var onShowDocument: ((URL) -> Void)?
    var onUploadEnabled: ((Bool) -> Void)?

    private let getCriteria: () async throws -> URL
    private let getTemplateCriteria: () async throws -> URL
    private let sendCriteria: (URL) async throws -> Void
    private let currentUser: () -> User?

    init(
        getCriteria: @escaping () async throws -> URL,
        getTemplateCriteria: @escaping () async throws -> URL,
        sendCriteria: @escaping (URL) async throws -> Void,
        currentUser: @escaping () -> User?
    ) {
        self.getCriteria = getCriteria
        self.getTemplateCriteria = getTemplateCriteria
        self.sendCriteria = sendCriteria
        self.currentUser = currentUser
    }
    
    func checkUploadCapability() {
        guard let user = currentUser() else {
            onUploadEnabled?(false)
            return
        }
        onUploadEnabled?(user.role == .admin)
    }
    
    func getCriteria() async {
        onShowLoading?(true)
        do {
            let localPathURL = try await getCriteria()
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
            try await sendCriteria(url)

            onShowLoading?(false)
            onUploadSuccees?()
        } catch {
            onShowLoading?(false)
            onErorr?(error.localizedDescription)
        }
    }
    
    func showCriteria() async {
        onShowLoading?(true)
        do {
            let localPathURL = try await getCriteria()
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
            let localFilePath = try await getTemplateCriteria()
            onShowLoading?(false)
            onShowDocument?(localFilePath)
        } catch {
            onShowLoading?(false)
            onErorr?(error.localizedDescription)
        }
    }
}

extension CriteriaViewModel {
    static func make() -> CriteriaViewModel {
        let getCriteria = GetCriteriaPath.make()
        let postCriteria = PostCriteria.make()
        return CriteriaViewModel(
            getCriteria: getCriteria.current,
            getTemplateCriteria: getCriteria.template,
            sendCriteria: postCriteria.postAndsave,
            currentUser: GetUser.user
        )
    }
}
