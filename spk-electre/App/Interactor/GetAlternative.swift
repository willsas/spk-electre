import Foundation
import SwiftCSV

struct GetAlternative {
    
    private let getAlternativePath: () async throws -> URL
    
    init(getAlternativePath: @escaping () async throws -> URL) {
        self.getAlternativePath = getAlternativePath
    }
    
    func get() async throws -> [Alternative] {
        var alternative = [Alternative]()
        let path = try await getAlternativePath()
        let csvFile: CSV = try CSV<Named>(url: path)
        
        csvFile.content.rows.forEach { dict in
            let name = dict[""]
            let criteriaDict = dict.compactMapValues { Double($0) }
            alternative.append(Alternative(name: name!, criteriaValues: criteriaDict))
        }
        
        return alternative
    }
}

extension GetAlternative {
    static func make() -> GetAlternative {
        .init(getAlternativePath: GetAlternativePath.make().current)
    }
}
