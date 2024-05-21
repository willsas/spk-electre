import Foundation

struct UploadFile {
    
    private let cloudFileManager: CloudFileManager
    
    init(cloudFileManager: CloudFileManager) {
        self.cloudFileManager = cloudFileManager
    }
    
    func upload(data: Data, name: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            cloudFileManager.uploadData(
                fileName: name,
                data: data,
                onSuccess: { continuation.resume() },
                onError: { continuation.resume(throwing: $0)}
            )
        }
    }
}

extension UploadFile {
    static func make() -> UploadFile {
        .init(cloudFileManager: CloudFileManager.shared)
    }
}
