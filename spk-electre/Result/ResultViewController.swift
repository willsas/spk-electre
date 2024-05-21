import UIKit

final class ResultViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let viewModel = ResultViewModel.make()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Result"
        addUserRightBarButtonItem()
        setupTableView()
        setupViewModel()
        searchBar.textDidChange { [weak self] in self?.viewModel.search(name: $0) }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task { [weak self] in await self?.viewModel.getResult() }
    }

    private func setupViewModel() {
        viewModel.onReload = { [weak self] in self?.tableView.reloadData() }
    }

    private func setupTableView() {
        tableView.register(
            .init(nibName: String(describing: AlternativeTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: "cell"
        )
        tableView.dataSource = self
    }
}

extension ResultViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.alternatives.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(
                withIdentifier: "cell",
                for: indexPath
            ) as? AlternativeTableViewCell
        else { return UITableViewCell() }

        let alternative = viewModel.alternatives[indexPath.row]
        cell.setup(
            name: alternative.name,
            criteria: dictionaryToDisplayString(data: alternative.criteriaValues)
        )

        return cell
    }

    private func dictionaryToDisplayString(data: [String: Double]) -> String {
        var displayString = ""
        for (key, value) in data {
            let formattedValue = String(format: "%.2f", value)
            displayString += "\(key): \(formattedValue), || "
        }
        return displayString
    }
}
