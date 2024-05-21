import Foundation

struct GetCriteriaPath {

    typealias LocalFilePath = URL

    private let fileName = Constant.criteriaFileName
    private let templateFileName = Constant.criteriaTemplateFileName

    private let download: (String) async throws -> Data
    private let save: (Data, String) throws -> Void
    private let retriveFromLocal: (String) throws -> URL

    init(
        download: @escaping (String) async throws -> Data,
        save: @escaping (Data, String) throws -> Void,
        retriveFromLocal: @escaping (String) throws -> URL
    ) {
        self.download = download
        self.save = save
        self.retriveFromLocal = retriveFromLocal
    }

    func current() async throws -> LocalFilePath {
        if let localFileURL = try? retriveFromLocal(fileName) {
            return localFileURL
        } else {
            let localFileURL = try await downloadAndSave(fileName: fileName)
            return localFileURL
        }
    }

    func template() async throws -> LocalFilePath {
        if let localFileURL = try? retriveFromLocal(templateFileName) {
            return localFileURL
        } else {
            let localFileURL = try await downloadAndSave(fileName: templateFileName)
            return localFileURL
        }
    }

    private func downloadAndSave(fileName: String) async throws -> URL {
        let downloadedData = try await download(fileName)
        _ = try save(downloadedData, fileName)
        return try retriveFromLocal(fileName)
    }
}

extension GetCriteriaPath {
    static func make() -> GetCriteriaPath {
        .init(
            download: DownloadFile.make().download,
            save: LocalFileManager.save,
            retriveFromLocal: LocalFileManager.retrive
        )
    }
}
