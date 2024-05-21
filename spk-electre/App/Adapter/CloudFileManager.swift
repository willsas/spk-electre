import FirebaseStorage
import Foundation

final class CloudFileManager {

    enum FileUploadError: Error {
        case errorUploadingFile
    }

    static let shared = CloudFileManager()
    private let storage = Storage.storage()

    func uploadData(
        fileName: String,
        data: Data,
        onSuccess: @escaping () -> Void,
        onError: @escaping (Error) -> Void
    ) {
        let storageRef = storage.reference().child(fileName)
        let uploadTask = storageRef.putData(data, metadata: nil)
        uploadTask.observe(.success) { _ in onSuccess() }
        uploadTask.observe(.failure) { snapshot in
            onError(snapshot.error ?? FileUploadError.errorUploadingFile)
        }
    }

    func downloadData(
        fileName: String,
        onSuccess: @escaping (Data) -> Void,
        onError: @escaping (Error) -> Void
    ) {
        let storageRef = storage.reference().child(fileName)
        storageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in // 10MB maximum file size
            if let error {
                onError(error)
                return
            }
            guard let data = data else { return }
            onSuccess(data)
        }
    }
}
