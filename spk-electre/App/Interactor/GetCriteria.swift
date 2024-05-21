import Foundation
import SwiftCSV

struct GetCriteria {
    
    private let getCriteriaPath: () async throws -> URL
    
    init(getCriteriaPath: @escaping () async throws -> URL) {
        self.getCriteriaPath = getCriteriaPath
    }
    
    func get() async throws -> [Criterion] {
        var criterions = [Criterion]()
        let path = try await getCriteriaPath()
        let csvFile: CSV = try CSV<Named>(url: path)
        
        csvFile.content.rows.forEach { dict in
            let name = dict["Nama"]
            let weight = dict["Bobot Kriteria (1-3)"]
            let code = dict["Kode"]
            criterions.append(Criterion(name: name!, weight: Double(weight!)!, code: code!))
        }
        
        return criterions
    }
}

extension GetCriteria {
    static func make() -> GetCriteria {
        .init(getCriteriaPath: GetCriteriaPath.make().current)
    }
}
