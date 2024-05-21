import Foundation

final class LocalFileManager {

    enum LocalFileManagerError: Error {
        case couldNotAccessDirectory
        case dataNotExist
    }

    static func save(_ data: Data, fileName: String) throws -> Void {
        guard let documentsDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first
        else { throw LocalFileManagerError.couldNotAccessDirectory }

        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        try data.write(to: fileURL)
    }

    static func retrive(fileName: String) throws -> URL {
        guard let documentsDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first
        else { throw LocalFileManagerError.couldNotAccessDirectory }

        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return fileURL
        } else {
            throw LocalFileManagerError.dataNotExist
        }
    }
}
