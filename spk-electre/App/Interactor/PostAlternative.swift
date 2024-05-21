import Foundation

struct PostAlternative {
    
    private let fileName = Constant.alternativeFileName

    private let upload: (Data, String) async throws -> Void
    private let save: (Data, String) throws -> Void

    init(
        upload: @escaping (Data, String) async throws -> Void,
        save: @escaping (Data, String) throws -> Void
    ) {
        self.upload = upload
        self.save = save
    }
    
    func postAndSave(localFilePath: URL) async throws -> Void {
        let data = try Data(contentsOf: localFilePath)
        try await upload(data, fileName)
        try save(data, fileName)
    }
}

extension PostAlternative {
    static func make() -> PostAlternative {
        .init(
            upload: UploadFile.make().upload,
            save: LocalFileManager.save
        )
    }
}
