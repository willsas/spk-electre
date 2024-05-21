import Foundation

@MainActor
final class HomeViewModel {
    
    var onUpdateAlternativeTitle: ((String) -> Void)?
    var onUpdateCriteriaTitle: ((String) -> Void)?
    
    private let getAlternatives: () async throws -> [Alternative]
    private let getCriterions: () async throws -> [Criterion]
    
    init(
        getAlternatives: @escaping () async throws -> [Alternative],
        getCriterions: @escaping () async throws -> [Criterion]
    ) {
        self.getAlternatives = getAlternatives
        self.getCriterions = getCriterions
    }
    
    func fetchAll() async {
        do {
            async let alternative = try await getAlternatives().count
            async let criterions = try await getCriterions().count
            
            let (alternativeCount, criterionCount) = try await (alternative, criterions)
            
            onUpdateAlternativeTitle?(
                "Lihat semua \(alternativeCount) Alternatif"
            )
            onUpdateCriteriaTitle?(
                "Lihat semua \(criterionCount) Kriteria"
            )
        } catch { }
    }
}

extension HomeViewModel {
    static func make() -> HomeViewModel {
        .init(getAlternatives: GetAlternative.make().get, getCriterions: GetCriteria.make().get)
    }
}
