import Foundation

@MainActor
final class AlternativeListViewModel {

    struct Display {
        let name: String
        let criteria: String
    }

    private let getAlternatives: () async throws -> [Alternative]
    private var allAlternative = [Display]()

    private(set) var alternatives = [Display]() { didSet { onReload?() }}
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

    init(getAlternatives: @escaping () async throws -> [Alternative]) {
        self.getAlternatives = getAlternatives
    }

    func fetch() async {
        do {
            let alternatives = try await getAlternatives()
            allAlternative = alternatives.map { $0.toDisplay() }
            self.alternatives = allAlternative
        } catch {}
    }

    func search(name: String) {
        search = name
    }
}

private extension Alternative {
    func toDisplay() -> AlternativeListViewModel.Display {
        .init(
            name: name,
            criteria: criteriaValues.map { "\($0.key) = \($0.value)" }
                .joined(separator: "\n")
        )
    }
}

extension AlternativeListViewModel {
    static func make() -> AlternativeListViewModel {
        .init(getAlternatives: GetAlternative.make().get)
    }
}
