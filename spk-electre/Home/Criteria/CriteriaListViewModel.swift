import Foundation

@MainActor
final class CriteriaListViewModel {

    private let getCriterions: () async throws -> [Criterion]
    private var allCriterions = [Criterion]()

    private(set) var criterions = [Criterion]() { didSet { onReload?() } }
    private var search: String = "" {
        didSet {
            if search.isEmpty {
                criterions = allCriterions
            } else {
                criterions = allCriterions
                    .filter { $0.name.lowercased().contains(search.lowercased()) }
            }
        }
    }

    var onReload: (() -> Void)?

    init(getCriterions: @escaping () async throws -> [Criterion]) {
        self.getCriterions = getCriterions
    }

    func fetch() async {
        do {
            let criterions = try await getCriterions()
            allCriterions = criterions
            self.criterions = allCriterions
        } catch {}
    }

    func search(name: String) {
        search = name
    }
}

extension CriteriaListViewModel {
    static func make() -> CriteriaListViewModel {
        .init(getCriterions: GetCriteria.make().get)
    }
}
