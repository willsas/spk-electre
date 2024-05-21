import Foundation

@MainActor
final class ResultViewModel {

    private let getAlternatives: () async throws -> [Alternative]
    private let getCriterions: () async throws -> [Criterion]
    private let calculateResult: ([Alternative], [Criterion]) -> [Alternative]

    private var allAlternative = [Alternative]()
    private(set) var alternatives = [Alternative]() { didSet { onReload?() }}
    private var search: String = "" {
        didSet {
            if search.isEmpty {
                alternatives = allAlternative
            } else {
                alternatives = allAlternative
                    .filter { $0.name.lowercased().contains(search.lowercased()) }
            }
        }
    }

    var onReload: (() -> Void)?

    init(
        getAlternatives: @escaping () async throws -> [Alternative],
        getCriterions: @escaping () async throws -> [Criterion],
        calculateResult: @escaping ([Alternative], [Criterion]) -> [Alternative]
    ) {
        self.getAlternatives = getAlternatives
        self.getCriterions = getCriterions
        self.calculateResult = calculateResult
    }

    func getResult() async {
        do {
            let alternatives = try await getAlternatives()
            let criterions = try await getCriterions()
            let result = calculateResult(alternatives, criterions)
            
            allAlternative = result
            self.alternatives = result
            
            onReload?()
        } catch {}
    }
    
    func search(name: String) {
        search = name
    }
}

extension ResultViewModel {
    static func make() -> ResultViewModel {
        .init(
            getAlternatives: GetAlternative.make().get,
            getCriterions: GetCriteria.make().get,
            calculateResult: { alternatives, criterions in
                ElectreAlgorithm(alternatives: alternatives, criteria: criterions).execute()
            }
        )
    }
}
