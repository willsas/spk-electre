import Foundation

struct DownloadFile {
    
    private let cloudFileManager: CloudFileManager
    
    init(cloudFileManager: CloudFileManager) {
        self.cloudFileManager = cloudFileManager
    }
    
    func download(name: String) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            cloudFileManager.downloadData(
                fileName: name,
                onSuccess: { continuation.resume(returning: $0) },
                onError: { continuation.resume(throwing: $0)}
            )
        }
    }
}

extension DownloadFile {
    static func make() -> DownloadFile {
        .init(cloudFileManager: CloudFileManager.shared)
    }
}
