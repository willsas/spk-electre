import Foundation

struct PostCriteria {
    
    private let fileName = Constant.criteriaFileName

    private let upload: (Data, String) async throws -> Void
    private let save: (Data, String) throws -> Void

    init(
        upload: @escaping (Data, String) async throws -> Void,
        save: @escaping (Data, String) throws -> Void
    ) {
        self.upload = upload
        self.save = save
    }
    
    func postAndsave(localFilePath: URL) async throws -> Void {
        let data = try Data(contentsOf: localFilePath)
        try await upload(data, fileName)
        try save(data, fileName)
    }
}

extension PostCriteria {
    static func make() -> PostCriteria {
        .init(
            upload: UploadFile.make().upload,
            save: LocalFileManager.save
        )
    }
}
