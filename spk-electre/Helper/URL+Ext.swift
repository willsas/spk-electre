import Foundation

extension URL {
    var fileName: String { lastPathComponent }
    var pathExtension: String { lastPathComponent.components(separatedBy: ".").last ?? "" }
}
